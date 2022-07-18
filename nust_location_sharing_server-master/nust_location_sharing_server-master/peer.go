package main

type Peer struct {
	Pid       string
	Ip        string
	Username  string
	Latitude  float64
	Longitude float64
}

func NewPeer(info *Info) *Peer {
	p := &Peer{
		Pid:       info.Pid,
		Ip:        info.Ip,
		Username:  info.Username,
		Latitude:  info.Latitude,
		Longitude: info.Longitude,
	}
	return p
}
func (r *Room) addPeer(p *Peer) {
	r.broadcastPeerEvent(r)
	r.peers[p.Pid] = p
}

func (r *Room) updatePeer(pid string, latitude float64, longitude float64) {
	r.peers[pid].Latitude = latitude
	r.peers[pid].Longitude = longitude
}

func findPeer(roomId string, pid string) bool {
	for k, _ := range roomList[roomId].peers {
		if k == pid {
			return true
		}
	}
	return false
}
func (r *Room) deltePeer(pid string) {
	if findPeer(r.roomId, pid) {
		delete(r.peers, pid)
	}
	if findRoom(r.roomId) {
		if len(r.peers) == 0 {
			deletRoom(r.roomId)
		}
	}
}
