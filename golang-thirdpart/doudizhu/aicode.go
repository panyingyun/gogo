package main

import (
	"bufio"
	"fmt"
	"math/rand"
	"os"
	"os/exec"
	"runtime"
	"sort"
	"strconv"
	"strings"
	"time"
)

// --- 基础配置 ---

// 牌值权重
const (
	Weight3  = 3
	Weight4  = 4
	Weight5  = 5
	Weight6  = 6
	Weight7  = 7
	Weight8  = 8
	Weight9  = 9
	Weight10 = 10
	WeightJ  = 11
	WeightQ  = 12
	WeightK  = 13
	WeightA  = 14
	Weight2  = 15
	WeightBJ = 16 // 小王
	WeightRJ = 17 // 大王
)

// 牌型常量
const (
	TypeInvalid = 0
	TypeSingle  = 1
	TypePair    = 2
	TypeTrip    = 3
	TypeBomb    = 4
	TypeRocket  = 5
)

var displayMap = map[int]string{
	3: "3", 4: "4", 5: "5", 6: "6", 7: "7", 8: "8", 9: "9", 10: "10",
	11: "J", 12: "Q", 13: "K", 14: "A", 15: "2", 16: "bj", 17: "RJ",
}

type Card struct {
	Weight int
	Suit   string
}

type CardSlice []Card

func (c CardSlice) Len() int           { return len(c) }
func (c CardSlice) Less(i, j int) bool { return c[i].Weight < c[j].Weight }
func (c CardSlice) Swap(i, j int)      { c[i], c[j] = c[j], c[i] }

type Player struct {
	ID      int
	Name    string
	Hand    CardSlice
	IsHuman bool
	IsLord  bool
}

type HandPattern struct {
	Type   int
	Weight int
	Count  int
}

var scanner = bufio.NewScanner(os.Stdin)

// --- 视觉显示核心 (ASCII Art) ---

// 画牌函数：将一手牌横向打印出来
func printCardsGraphic(cards CardSlice, showIndex bool) {
	if len(cards) == 0 {
		return
	}

	lines := make([]string, 6) // 一张牌高5行 + 1行索引

	for i, c := range cards {
		valStr := displayMap[c.Weight]
		suitStr := c.Suit

		// 调整对齐
		padding := ""
		if len(valStr) == 1 {
			padding = " "
		}

		// 特殊处理大小王
		if c.Weight == WeightBJ {
			valStr = "BJ"
			suitStr = "★"
			padding = ""
		} else if c.Weight == WeightRJ {
			valStr = "RJ"
			suitStr = "★"
			padding = ""
		}

		// 拼接每一行 (画框)
		// ┌────┐
		// │ 3  │
		// │ ♠  │
		// │  3 │
		// └────┘

		lines[0] += "┌────┐ "
		lines[1] += fmt.Sprintf("│%s%s │ ", valStr, padding)
		lines[2] += fmt.Sprintf("│ %s  │ ", suitStr)
		lines[3] += fmt.Sprintf("│ %s%s│ ", padding, valStr)
		lines[4] += "└────┘ "

		// 底部索引
		if showIndex {
			idxStr := strconv.Itoa(i)
			if i < 10 {
				lines[5] += fmt.Sprintf("  %s    ", idxStr)
			} else {
				lines[5] += fmt.Sprintf("  %s   ", idxStr)
			}
		}
	}

	// 打印所有行
	for _, line := range lines {
		fmt.Println(line)
	}
}

func clearScreen() {
	var cmd *exec.Cmd
	if runtime.GOOS == "windows" {
		cmd = exec.Command("cmd", "/c", "cls")
	} else {
		cmd = exec.Command("clear")
	}
	cmd.Stdout = os.Stdout
	cmd.Run()
}

func createDeck() CardSlice {
	suits := []string{"♠", "♥", "♣", "♦"}
	var deck CardSlice
	for w := 3; w <= 15; w++ {
		for _, s := range suits {
			deck = append(deck, Card{Weight: w, Suit: s})
		}
	}
	deck = append(deck, Card{Weight: WeightBJ, Suit: " "})
	deck = append(deck, Card{Weight: WeightRJ, Suit: " "})
	return deck
}

// --- 核心逻辑 ---

func analyzeHand(cards CardSlice) HandPattern {
	count := len(cards)
	if count == 0 {
		return HandPattern{Type: TypeInvalid}
	}
	sort.Sort(cards)
	first := cards[0].Weight

	if count == 1 {
		return HandPattern{Type: TypeSingle, Weight: first, Count: 1}
	}
	if count == 2 {
		if cards[0].Weight == cards[1].Weight {
			return HandPattern{Type: TypePair, Weight: first, Count: 2}
		}
		if cards[0].Weight >= WeightBJ && cards[1].Weight >= WeightBJ {
			return HandPattern{Type: TypeRocket, Weight: 100, Count: 2}
		}
	}
	if count == 3 {
		if cards[0].Weight == cards[1].Weight && cards[1].Weight == cards[2].Weight {
			return HandPattern{Type: TypeTrip, Weight: first, Count: 3}
		}
	}
	if count == 4 {
		if cards[0].Weight == cards[1].Weight && cards[2].Weight == cards[3].Weight && cards[0].Weight == cards[3].Weight {
			return HandPattern{Type: TypeBomb, Weight: first, Count: 4}
		}
	}
	return HandPattern{Type: TypeInvalid}
}

func canBeat(prev HandPattern, current HandPattern) bool {
	if current.Type == TypeInvalid {
		return false
	}
	if current.Type == TypeRocket {
		return true
	}
	if prev.Type == TypeRocket {
		return false
	}
	if current.Type == TypeBomb && prev.Type != TypeBomb {
		return true
	}
	if current.Type == prev.Type && current.Count == prev.Count {
		return current.Weight > prev.Weight
	}
	return false
}

func removeCards(p *Player, indexes []int) {
	toDelete := make(map[int]bool)
	for _, idx := range indexes {
		toDelete[idx] = true
	}
	var newHand CardSlice
	for i, c := range p.Hand {
		if !toDelete[i] {
			newHand = append(newHand, c)
		}
	}
	p.Hand = newHand
}

// --- 主程序 ---

func main() {
	rand.Seed(time.Now().UnixNano())
	clearScreen()

	fmt.Println("============================================")
	fmt.Println("        Go 语言斗地主 (字符画版)")
	fmt.Println("============================================")
	time.Sleep(1 * time.Second)

	// 1. 洗牌
	deck := createDeck()
	rand.Shuffle(len(deck), func(i, j int) { deck[i], deck[j] = deck[j], deck[i] })

	// 2. 发牌
	players := []*Player{
		{ID: 0, Name: "你", IsHuman: true},
		{ID: 1, Name: "电脑左", IsHuman: false},
		{ID: 2, Name: "电脑右", IsHuman: false},
	}

	for i := 0; i < 51; i++ {
		players[i%3].Hand = append(players[i%3].Hand, deck[i])
	}
	lordCards := deck[51:]
	for _, p := range players {
		sort.Sort(p.Hand)
	}

	// 3. 抢地主
	fmt.Println("你的手牌:")
	printCardsGraphic(players[0].Hand, true)

	lordIndex := -1
	for {
		fmt.Print("\n你要抢地主吗? (输入 y 或 n): ")
		scanner.Scan()
		input := strings.TrimSpace(strings.ToLower(scanner.Text()))
		if input == "y" {
			lordIndex = 0
			break
		} else if input == "n" {
			lordIndex = rand.Intn(2) + 1
			break
		}
	}

	players[lordIndex].IsLord = true
	players[lordIndex].Hand = append(players[lordIndex].Hand, lordCards...)
	sort.Sort(players[lordIndex].Hand)

	fmt.Printf("\n>>> %s 抢到了地主! <<<\n", players[lordIndex].Name)
	fmt.Println("底牌是:")
	printCardsGraphic(lordCards, false)

	// 4. 出牌
	turn := lordIndex
	lastValidPattern := HandPattern{Type: TypeInvalid}
	passCount := 0

	for {
		curr := players[turn]
		if len(curr.Hand) == 0 {
			fmt.Printf("\n🎉🎉 %s 赢了! 🎉🎉\n", curr.Name)
			break
		}

		// 新回合重置
		isNewRound := false
		if passCount >= 2 {
			isNewRound = true
			lastValidPattern = HandPattern{Type: TypeInvalid}
			fmt.Println("\n----------------------------------")
			fmt.Println("无人出牌，新回合开始")
			fmt.Println("----------------------------------")
		}

		fmt.Printf("\n轮到 [%s] (剩余 %d 张)\n", curr.Name, len(curr.Hand))

		played := false
		if curr.IsHuman {
			// 玩家操作
			printCardsGraphic(curr.Hand, true) // 显示带索引的牌
			if !isNewRound {
				fmt.Printf("上家打出了 (权重%d): \n", lastValidPattern.Weight)
			}

			for {
				fmt.Print("输入牌的序号 (如 '0 1' 出对3), 或 'p' 过: ")
				scanner.Scan()
				input := strings.TrimSpace(scanner.Text())

				if input == "p" {
					if isNewRound {
						fmt.Println("你是先手，必须出牌！")
						continue
					}
					fmt.Println(">>> 你选择了过")
					passCount++
					played = false
					break
				}

				// 解析
				idxStrs := strings.Split(input, " ")
				var idxs []int
				valid := true
				for _, s := range idxStrs {
					val, err := strconv.Atoi(s)
					if err != nil || val < 0 || val >= len(curr.Hand) {
						valid = false
						break
					}
					idxs = append(idxs, val)
				}

				if !valid || len(idxs) == 0 {
					fmt.Println("输入错误，请重新输入序号。")
					continue
				}

				// 校验牌型
				var selCards CardSlice
				for _, id := range idxs {
					selCards = append(selCards, curr.Hand[id])
				}

				ptn := analyzeHand(selCards)
				if ptn.Type == TypeInvalid {
					fmt.Println("❌ 牌型不合法 (只支持单/对/三/炸/王炸)")
					continue
				}

				if isNewRound || canBeat(lastValidPattern, ptn) {
					fmt.Println(">>> 你打出了:")
					printCardsGraphic(selCards, false)
					removeCards(curr, idxs)
					lastValidPattern = ptn
					passCount = 0
					played = true
					break
				} else {
					fmt.Println("❌ 打不过上家！")
				}
			}

		} else {
			// AI 操作
			time.Sleep(1 * time.Second)

			// AI 极简策略
			aiHand := curr.Hand
			var idxs []int
			found := false

			if isNewRound {
				// 出最小一张
				idxs = []int{0}
				found = true
			} else {
				// 简单跟牌逻辑 (仅做演示)
				if lastValidPattern.Type == TypeSingle {
					for i, c := range aiHand {
						if c.Weight > lastValidPattern.Weight {
							idxs = []int{i}
							found = true
							break
						}
					}
				} else if lastValidPattern.Type == TypePair {
					for i := 0; i < len(aiHand)-1; i++ {
						if aiHand[i].Weight == aiHand[i+1].Weight && aiHand[i].Weight > lastValidPattern.Weight {
							idxs = []int{i, i + 1}
							found = true
							break
						}
					}
				}
				// 炸弹
				if !found && lastValidPattern.Type != TypeBomb && lastValidPattern.Type != TypeRocket {
					for i := 0; i < len(aiHand)-3; i++ {
						if aiHand[i].Weight == aiHand[i+3].Weight {
							idxs = []int{i, i + 1, i + 2, i + 3}
							found = true
							break
						}
					}
				}
			}

			if found {
				var playCards CardSlice
				for _, i := range idxs {
					playCards = append(playCards, aiHand[i])
				}
				ptn := analyzeHand(playCards)

				fmt.Printf(">>> %s 打出了:\n", curr.Name)
				printCardsGraphic(playCards, false)
				removeCards(curr, idxs)
				lastValidPattern = ptn
				passCount = 0
				played = true
			} else {
				fmt.Printf(">>> %s 不要\n", curr.Name)
				passCount++
				played = false
			}
		}
		turn = (turn + 1) % 3
		fmt.Println("played: ", played)
	}

	fmt.Println("游戏结束，按回车退出")
	scanner.Scan()
}
