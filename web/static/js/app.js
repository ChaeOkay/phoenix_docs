// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "deps/phoenix_html/web/static/js/phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

import {Socket} from "deps/phoenix/web/static/js/phoenix"

let App = {
  init(){
    let socket = new  Socket("/socket")
    let editor = new Quill("#editor")
    let docID = $("#editor").data("id")

    let msgContainer = $("messages")
    let msgInput = $("#message-input")
    socket.connect() //idel connection - see web/channels/document_channel

    let docChan = socket.channel("documents:" + docID)

    docChan.on("text_change", ({delta}) => {
      editor.updateContents(delta)
    })

    docChan.on("new_msg", msg => {
      this.appendMessage(msgContainer. msg)
    })


    editor.on('text-change', (delta, source) => {
      if (source !== "user"){ return }

      docChan.push("text_change", {delta: delta})
    })

    msgInput.on("keypress", e => {
      if(e.which !== 13) { return }
      docChan.push("new_msg", {body: msgInput.val()})
      msgInput.val("")
    })

    docChan.join()
      .receive("ok", resp => console.log("Joined!", resp) )
      .receive("error", resp => console.log("Error!", resp) )
  },

  appendMessage(msgContainer, msg){
    msgContainer.append(`<br/>${msg.body}`)
    msgContainer.scrollTop(msgContainer.props("scrollHeight"))
  }
}

App.init()
