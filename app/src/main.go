package main

import (
	"bufio"
	"fmt"
	"net/http"
	"os"
	"strings"
)

func main() {
	reader := bufio.NewReader(os.Stdin)

	var name string
	for {
		fmt.Print("Input your name: ")
		input, err := reader.ReadString('\n')
		if err != nil {
			fmt.Fprintln(os.Stderr, "Error reading input:", err)
			continue
		}

		name = strings.TrimSpace(input)
		if name != "" {
			break
		}
		fmt.Println("Name cannot be empty. Please try again.")
	}

	var port string = "8000"

	fmt.Printf("Name accepted: %s\n", name)
	fmt.Printf("Starting web server on http://localhost:%s\n", port)

	// register handler
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "<h1>Hello, %s!</h1>", name)
	})

	// start server
	// err := http.ListenAndServe("localhost:"+port, nil)
	err := http.ListenAndServe(":"+port, nil)
	if err != nil {
		fmt.Fprintln(os.Stderr, "Server failed:", err)
	}
}
