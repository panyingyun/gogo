package helper

import (
	"context"
	"fmt"
	"log"
	"os"
	"path"
	"strconv"
	"strings"

	repl "github.com/openengineer/go-repl"
	gorm "gorm.io/gorm"
)

const (
	DBName      string = "realm.db"
	MainDomain  string = "main.passwd"
	HelpMessage string = `help              display this message
login <string> login with main passwd
add <string> <string>   add domain and passwd
count                  query how many domain
query <string> query domain's passwd
quit              quit this program
exit              quit this program`
)

// implements repl.Handler interface
type RealmHandler struct {
	ctx     context.Context
	db      *gorm.DB
	r       *repl.Repl
	mainPwd string
}

func RunReplCmder() {
	fmt.Println("type \"help\" for more info")
	dir, err := os.Getwd()
	if err != nil {
		log.Fatal(err)
	}
	// fmt.Println("dir = ", dir)
	realmdb, err := OpenDB(path.Join(dir, DBName))

	h := &RealmHandler{
		ctx: context.Background(),
		db:  realmdb,
	}
	h.r = repl.NewRepl(h)

	// start the terminal loop
	if err := h.r.Loop(); err != nil {
		log.Fatal(err)
	}
}

func (rh *RealmHandler) Prompt() string {
	return "> "
}

func (rh *RealmHandler) Tab(buffer string) string {
	return "" // do nothing
}

func (rh *RealmHandler) Eval(line string) string {
	fields := strings.Fields(line)

	if len(fields) == 0 {
		return ""
	} else {
		cmd, args := fields[0], fields[1:]

		switch cmd {
		case "help":
			return HelpMessage
		case "login":
			if len(args) != 1 {
				return "\"login\" expects 1 args, like \"login [passwd]\""
			} else {
				return rh.login(args[0])
			}
		case "add":
			if len(args) != 2 {
				return "\"add\" expects 2 args, like \"add www.google.com, [passwd]\""
			} else {
				return rh.add(args[0], args[1])
			}
		case "query":
			if len(args) != 1 {
				return "\"query\" expects 1 args, like \"query www.google.com\""
			} else {
				return rh.query(args[0])
			}
		case "count":
			if len(args) != 0 {
				return "\"count\" expects 0 args, like \"count\""
			} else {
				return rh.counter()
			}
		case "exit", "quit":
			rh.r.Quit()
			return ""
		default:
			return fmt.Sprintf("unrecognized command \"%s\"", cmd)
		}
	}
}

func (rh *RealmHandler) login(mainPwd string) string {
	if isStringBlank(mainPwd) {
		return "main passwd can not be blank."
	}
	pwddOri := QueryDomain(rh.db, MainDomain)
	pwdd, _ := GetAESEncrypted(mainPwd, mainPwd)
	// fmt.Println("MainDomain = ", MainDomain)
	// fmt.Println("pwdd = ", pwdd)
	if len(pwddOri) == 0 {
		AddDomain(rh.db, MainDomain, pwdd)
		rh.mainPwd = mainPwd
		return "login success. Your first set your main passwd."
	}
	if pwdd == pwddOri {
		rh.mainPwd = mainPwd
		return "login success."
	} else {
		return "login fail. Your main passwd is not right."
	}
}

func (rh *RealmHandler) add(domain string, pwd string) string {
	pwdd := QueryDomain(rh.db, domain)
	pwddNew, _ := GetAESEncrypted(rh.mainPwd, pwd)
	if len(pwdd) == 0 {
		// create
		AddDomain(rh.db, domain, pwddNew)
	} else {
		// update
		UpdateDomainPasswd(rh.db, domain, pwddNew)
	}
	return "add"
}

func (rh *RealmHandler) query(domain string) string {
	pwdd := QueryDomain(rh.db, domain)
	pwd, _ := GetAESDecrypted(rh.mainPwd, pwdd)
	return pwd
}

func (rh *RealmHandler) counter() string {
	cnt := Counter(rh.db)
	return strconv.FormatInt(cnt, 10)
}
