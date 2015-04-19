using UnityEngine;
using System.Collections;

public class CPlayer : MonoBehaviour {

    Animator anim;
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
        anim = this.GetComponent<Animator>();
	}
	
	// Update is called once per frame
	void FixedUpdate () 
    {
        if (!alive) 
        {
            DestroyObject(gameObject);
        }
        position = this.transform.localPosition;
        this.transform.localEulerAngles = new Vector3(0,this.transform.localEulerAngles.y,0);
        move();
        digg();
        dance();
    }

    private void move()
    {
        //camera view direction
        Vector3 viewDirection = position - Camera.main.transform.localPosition;
        viewDirection.y = 0;
        viewDirection.Normalize();
        viewDirection=Camera.main.transform.localToWorldMatrix.MultiplyVector(viewDirection);
        viewDirection = this.transform.TransformDirection(viewDirection);
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
        if (Input.GetKey(KeyCode.E))
        {
            this.transform.localEulerAngles = new Vector3(0, this.transform.localEulerAngles.y + 1, 0);
        }
        else if (Input.GetKey(KeyCode.Q))
        {
            this.transform.localEulerAngles = new Vector3(0, this.transform.localEulerAngles.y - 1, 0);
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
            anim.SetTrigger("Hoo");
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
            hit = true;}
        else
        {
            hit = false;
        }
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
            fearBar += 5;
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
            Vector3 direction = coll.gameObject.transform.localPosition - position;
            direction.y = 0;
            this.transform.localPosition += 0.3f * direction;
        }
    }
    void OnTriggerExit(Collider coll) 
    {
        movementSpeed = 0.2f;  
    }
}
