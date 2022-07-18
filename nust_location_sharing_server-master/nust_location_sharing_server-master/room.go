package main

type Room struct {
	roomId string
	peers  map[string]*Peer
}

func (r *Room) broadcastPeerEvent(r2 *Room) {

}

func NewRoom(rid string, peer *Peer) *Room {
	r := &Room{
		roomId: rid,
		peers:  make(map[string]*Peer),
	}
	r.addPeer(peer)
	return r
}

func findRoom(rid string) bool {

	for roomId, _ := range roomList {
		if roomId == rid {
			return true
		}
	}

	//deletRoom(rid)
	return false
}
func updateRoom() {

}
func deletRoom(rommId string) {
	delete(roomList, rommId)
}
