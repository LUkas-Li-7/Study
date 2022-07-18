package main

import (
	"encoding/json"
	"fmt"
	"sync"

	//"github.com/go-redis/redis"
	//"github.com/go-redis/redis/v7"
	"log"
	"net/http"
)

type Info struct {
	Ip        string  `json:"ip"`
	Username  string  `json:"username"`
	Latitude  float64 `json:"latitude"`
	Longitude float64 `json:"longitude"`
	Pid       string  `json:"pid"`
	Rid       string  `json:"rid"`
	State     int     `json:"state"`
}

type ReturnInfo struct {
	Pid string
}

var lock sync.Mutex
var (
	formData  = make(map[string]interface{})
	roomList  = make(map[string]*Room)
	returnMap = make(map[string]interface{})
	peerSlice = make([]*Peer, 0)
)

func main() {
	http.HandleFunc("/get", IndexHandler)
	err := http.ListenAndServe("0.0.0.0:15553", nil)
	if err != nil {
		return
	}
}

func IndexHandler(w http.ResponseWriter, r *http.Request) {
	lock.Lock()
	err := r.ParseForm()
	fmt.Println(r.Body)
	if err != nil {
		log.Fatal("parse form error ", err)
	}
	// 初始化请求变量结构\

	// 调用json包的解析，解析请求body
	json.NewDecoder(r.Body).Decode(&formData)
	jsons, _ := json.Marshal(formData)
	//log.Println("req form: ", formData)
	for key, value := range formData {
		log.Println("key:", key, " => value :", value)
	}
	var info Info
	unmarshalErr := json.Unmarshal(jsons, &info)
	if unmarshalErr != nil {
		log.Fatal("json error")
		return
	}
	if info.State == 1 {
		//room addPeer
		log.Println(info.Rid)
		if findRoom(info.Rid) {
			log.Println("findRoom is true")
			if findPeer(info.Rid, info.Pid) {
				log.Println("findPeer is true")
				roomList[info.Rid].updatePeer(info.Pid, info.Latitude, info.Longitude)
			} else {
				roomList[info.Rid].addPeer(&Peer{
					Ip:        info.Ip,
					Pid:       info.Pid,
					Username:  info.Username,
					Latitude:  info.Latitude,
					Longitude: info.Longitude,
				})
			}
		} else {
			peer := NewPeer(&info)
			room := NewRoom(info.Rid, peer)

			roomList[room.roomId] = room
		}

	} else {
		if findRoom(info.Rid) {
			if findPeer(info.Rid, info.Pid) {
				roomList[info.Rid].deltePeer(info.Pid)
			}
		}
	}
	if len(roomList) != 0 {
		for peer, v := range roomList[info.Rid].peers {
			log.Println("peerId " + peer)
			peerSlice = append(peerSlice, v)
			marshal, err := json.Marshal(ReturnInfo{Pid: peer})
			log.Println(string(marshal))
			if err != nil {
				fmt.Printf("Map转化为byte数组失败,异常:%s\n", err)
				return
			}
		}
	} else {
	}
	returnMap["locationInfos"] = peerSlice
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(returnMap)
	peerSlice = peerSlice[0:0]
	lock.Unlock()
}
