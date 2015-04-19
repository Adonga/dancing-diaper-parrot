﻿using UnityEngine;
using System.Collections;

public class CPlayer : MonoBehaviour {

    static public Vector3 position;
    bool hit;
    bool alive;
    static public bool underGround;
    static public int fearBar;
  public  float movementSpeed;
    float up;
    //private Animation anim;
	void Start () 
    {
        position = new Vector3(2, 1, 2);
        this.transform.localPosition = position;
        position = this.transform.localPosition;
        up = this.transform.localEulerAngles.y;
        //anim = this.GetComponent<Animation>();
        hit = false;
        alive = true;
        underGround = false;
        fearBar = 0;
        movementSpeed = 0.2f;
       /* if (!GetComponent<Animation>().isPlaying)
        {
            GetComponent<Animation>().Play("Run");
        }*/

	}
	
	// Update is called once per frame
	void FixedUpdate () 
    {
        position = this.transform.localPosition;
        this.transform.localEulerAngles = new Vector3(0,up,0);
        move();
        digg();
        dance();
        dash();
    }

    private void move()
    {   
        if (Input.GetKey(KeyCode.D))
        {
            position.x += movementSpeed;
            this.transform.localPosition = position;
        }
        else if (Input.GetKey(KeyCode.A))
        {
            position.x -= movementSpeed;
            this.transform.localPosition = position;
        }
        if (Input.GetKey(KeyCode.W))
        {
            position.z+= movementSpeed;
            this.transform.localPosition = position;
        }
        else if (Input.GetKey(KeyCode.S))
        {
            position.z -= movementSpeed;
            this.transform.localPosition = position;
        }
        //jump
        if (Input.GetKey(KeyCode.Space))
        {
            position.y += 0.2f;
            this.transform.localPosition = position;
        }
        if (underGround) 
        {
            position.y = -5;
            this.transform.localPosition = position;
        }

    }

    private void digg() {
        if (Input.GetKeyDown(KeyCode.Tab) && !underGround) 
        {
            underGround = true;
            this.transform.localPosition = new Vector3(position.x,-5,position.z);
        }
        else if (Input.GetKeyDown(KeyCode.Tab)) 
        {
            underGround = false;
            this.transform.localPosition = new Vector3(position.x,1,position.z);
        }

    }
    private void dance() 
    {
        //do dancing stuff
        if (Input.GetKey(KeyCode.F))
        {
            hit = true;
      //      Debug.Log("Dance");
        }
        else
        {
            hit = false;
        }
    }
    private void dash()
    {
        if (Input.GetKeyDown(KeyCode.F))
        {
            position = this.transform.localPosition;
            
        }
    }
    Vector3 GetEnemyPosition() 
    {
        return new Vector3(0, 0, 0);
    }
    void OnCollisionEnter(Collision coll)
    {
        if (coll.gameObject.tag == "Enemy" && !hit)
        {
            //         Debug.Log("Dead");
            alive = false;
            DestroyObject(gameObject);
        }
        else if (coll.gameObject.tag == "Enemy")
        {
            movementSpeed = 0.2f;
        }
    }
    void OnTriggerEnter(Collider coll) 
    {
        if (coll.gameObject.tag == "Enemy" && !underGround) 
        {
            movementSpeed = 0.05f;
        }
        
    }
    void OnTriggerStay(Collider coll) 
    {
        if (coll.gameObject.tag == "Enemy" && hit) 
        {
            movementSpeed = 0.8f;
        }
    }
    void OnTriggerExit(Collider coll) 
    {
        movementSpeed = 0.2f;  
    }
}
