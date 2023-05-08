package main

import (
	"flag"
	"net/http"
)

func main() {
	port := flag.String("p", "4000", "a port")
	dir := flag.String("d", "./", "a dir")

	flag.Parse()
	http.ListenAndServe(":"+*port, http.FileServer(http.Dir(*dir)))

}

////////
package main

import "os"
import "net/http"

func main() {
	panic(http.ListenAndServe(":"+os.Args[1], http.FileServer(http.Dir(os.Args[2]))))
}

///////golang 交叉编译

1.Mac下编译Linux，windows平台的64位可执行程序：

　　CGO_ENABLE=0 GOOS=linux GOARCH=amd64 go build main.go

　　CGO_ENABLE=0 GOOS=windows GOARCH=amd64 go build main.go

2.Linux下编译Mac，Windows平台的64位可执行程序：

　　CGO_ENABLE=0 GOOS=darwin GOARCH=amd64 go build main.go

　　CGO_ENABLE=0 GOOS=windows  GOARCH=amd64 go build main.go

3，Windows下编译mac，Linux平台64可执行程序：

　　set CGO_ENABLE=0

　　set GOOS=darwin

　　set GOARCH=amd64

　　go build main.go

 

　　set CGO_ENABLE=0

　　set GOOS=linux

　　set GOARCH=amd64

　　go build main.go


//////////////////////////////////auth//////////
package main

import (
	"flag"
	"github.com/gin-gonic/gin"
	"net/http"
)

func main() {

	port := flag.String("p", "9002", "a port")
	dir := flag.String("d", "mm", "a dir")
	user := flag.String("u", "aaa", "username")
	key := flag.String("k", "aaa", "password")
	flag.Parse()

	gin.SetMode(gin.ReleaseMode)
	r := gin.New()

	authorized := r.Group("", gin.BasicAuth(gin.Accounts{*user: *key}))

	authorized.StaticFS("", http.Dir(*dir))
	r.Run(":" + *port)
}

///////////s7///////with subdir secret///////
package main

import (
	"flag"
	"net/http"
)

func main() {
	port := flag.String("p", "9001", "a port")
	dir := flag.String("d", "tmp", "a dir")
	tag := flag.String("t", "dd", "a tag")
	flag.Parse()
	sub := "/" + *tag + "/"

	http.Handle(sub, http.StripPrefix(sub, http.FileServer(http.Dir(*dir))))
	http.ListenAndServe(":"+*port, nil)
}
///////////////////////////////////////////////

e.g.     ./s7 -d \.\/

///////////// webdav with a prefix wd.go ////////////

package main

import (
        "flag"
        "net/http"
         "golang.org/x/net/webdav"
)

func main() {
        port := flag.String("p", "9001", "a port")
        dir := flag.String("d", "/root/tmp", "a dir")
        tag := flag.String("t", "dd", "a tag")
        flag.Parse()
        sub := "/" + *tag + "/"
    handler := &webdav.Handler{
        FileSystem: webdav.Dir(*dir),
        LockSystem: webdav.NewMemLS(),
    }

        http.Handle(sub, http.StripPrefix(sub, handler))
        http.ListenAndServe(":"+*port, nil)
}

