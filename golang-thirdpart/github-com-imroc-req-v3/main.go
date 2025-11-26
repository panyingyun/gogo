package main

import (
	"fmt"

	req "github.com/imroc/req/v3"
)

type IPResult struct {
	Result string `json:"result"` //用户名
	Status int    `json:"status"` //密码
}

// "https://ip.michaelapp.com/query?ip=115.198.111.150"
func main() {
	client := req.C(). // Use C() to create a client and set with chainable client settings.
				SetUserAgent("ys-agent").
				SetTimeout(0).DevMode()
	var ret IPResult
	resp, err := client.R(). // Use R() to create a request and set with chainable request settings.
					SetHeader("Accept", "application/json").
					SetSuccessResult(&ret).SetQueryParam("ip", "115.198.111.150").
					Get("https://ip.michaelapp.com/query")

	if resp.IsSuccessState() {
		fmt.Println(ret.Result)
	} else {
		fmt.Println(err)
	}
}
