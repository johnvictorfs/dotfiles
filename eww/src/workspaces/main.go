package main

// NICKED FROM https://github.com/liamg/dotfiles/blob/master/eww/src/workspaces/main.go
// + and https://github.com/owenrumney/eww-bar

import (
	"fmt"
	"os"
	"strconv"

	"go.i3wm.org/i3/v4"
)

func main() {

	if len(os.Args) <= 1 {
		panic("please supply output number")
	}

	index, err := strconv.Atoi(os.Args[1])
	if err != nil {
		panic(err)
	}

	updateWorkspaces(index)

	subscription := i3.Subscribe(i3.WorkspaceEventType)
	for subscription.Next() {
		event := subscription.Event()
		switch event.(type) {
		case *i3.WorkspaceEvent:
			updateWorkspaces(index)
		}
	}
}

func updateWorkspaces(outputIndex int) {
	workspaces, err := i3.GetWorkspaces()
	if err != nil {
		fmt.Printf("Error: %s\n", err)
		return
	}

	var outputName string
	outputs, err := i3.GetOutputs()
	if err != nil {
		fmt.Printf("Error: %s\n", err)
		return
	}
	if outputIndex < len(outputs) {
		outputName = outputs[outputIndex].Name
	}

	// open box
	fmt.Printf(`(box 	:orientation "h"	:space-evenly false  :spacing 10`)
	for _, workspace := range workspaces {

		if workspace.Output != outputName {
			continue
		}

		var class string
		if workspace.Urgent {
			class = "urgent"
		} else if workspace.Focused {
			class = "focused"
		}

		// var names = strings.Split(workspace.Name, ":")
		// var name_only = names[len(names)-1]

		// If workspace doesn't have an icon, just use the workspace number instead
		// if strings.TrimSpace(name_only) == "" {
		// 	name_only = fmt.Sprint(workspace.Num)
		// }

		fmt.Printf(
			`(button `+
				`:onclick "i3-msg workspace '%s'"`+
				`:class '%s'`+
				`(label :text '%s'))`,
			workspace.Name,
			class,
			workspace.Name,
		)
	}

	// close box + newline for send
	fmt.Println(")")
}
