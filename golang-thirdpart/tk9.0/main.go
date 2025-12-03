package main

import tk "modernc.org/tk9.0"

//https://gosuda.org/zh/blog/posts/creating-a-gui-with-tk-in-go-z004dd008

func main() {
	tk.Pack(
		tk.TButton(
			tk.Txt("Hello, TK!"),
			tk.Command(func() {
				tk.Destroy(tk.App)
			})),
		tk.Ipadx(10), tk.Ipady(5), tk.Padx(15), tk.Pady(10),
	)
	tk.App.Wait()
}
