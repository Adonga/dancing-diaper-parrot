using UnityEngine;
using System.Collections;

public class Dest : MonoBehaviour {

	void Start () {
        CGameSingelton.instance.destinatinPosition = this.transform.localPosition;
	}
    void OnCollisionEnter(Collision coll) 
    {
        if (coll.gameObject.tag == "Player" && CGameSingelton.instance.egg > 0) 
        {
            coll.gameObject.transform.localPosition = new Vector3();
            CGameSingelton.instance.win = true;
        }
        
    }
}
