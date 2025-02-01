#include <iostream> 
#include <stdlib.h>
#include <iomanip>
#include <string.h>
#include <string>
#include <fstream>
#include <vector>
#include <algorithm>
#include <stack>
#include <iomanip>
#include <chrono>
#include <random>

using namespace std;
using namespace std::chrono;

vector<string> publishers;
void ordercsv(string);

/////////////////// Player ///////////////////
class publisher
{
public:
	string name;
	float na_sales;
	float eu_sales;
	float others_sales;
};

/////////////////// Node ///////////////////
class Node{
	public:
		publisher key;
		int color; // "Red"=1 or "Black"=0
		Node *parent, *left, *right;
	
		Node(publisher);
		~Node();
		int get_color();
        void set_color(int);
};

/////////////////// RB-Tree ///////////////////
class RB_tree{
	private:
		Node* root;
	public:	
        publisher* best_seller[3];	
		stack<string> tree_deep_stack;

        Node* get_root();

		Node* RB_insert(Node* root, Node* ptr);
        void insertValue(vector<string>);
		void RB_left_rotate(Node*);
		void RB_right_rotate(Node*);
		void RB_insert_fixup(Node*);
        void preorder();
        void actual_preorder(Node*, string);
        void preorder_for_bestseller(Node*);
        void find_best_seller(); 
        Node* find_publisher(string);

        
        RB_tree();
		~RB_tree();
};

void print_best_sellers(int year, publisher* temp_publisher[3]){
    cout.precision(5);
    cout<< "End of the "+to_string(year)+" Year"<<endl;
    cout<< "Best seller in North America: "+temp_publisher[0]->name+" - "<<temp_publisher[0]->na_sales<<" million"<<endl;
    cout<< "Best seller in Europe: "+temp_publisher[1]->name+" - "<<temp_publisher[1]->eu_sales<<" million"<<endl;
    cout<< "Best seller rest of the World: "+temp_publisher[2]->name+" - "<<temp_publisher[2]->others_sales<<" million"<<endl;
}

RB_tree generate_RBT_tree_from_csv(string file_name){
	RB_tree temp_RBtree;
    
    // Fill this function.

    //1-read a line from csv
	//Open csv file
    std::ifstream file(file_name);
    std::string line;
	//to print out the max sales
	bool printed2020 = false;
	bool printed2010 = false;
	bool printed2000 = false;
	bool printed1990 = false;
    if (!file.is_open()) {
        std::cout << "Error::Can not open the file " << file_name << std::endl;
    }else{
		
		//get rid of the first line
        std::getline(file, line);
		//start reading
		int row = 1;
		vector<vector<string>> row_values;
		while(std::getline(file, line)){
            std::stringstream item_line(line);

            std::string name = "";                   
            std::string platform = "";
			std::string year_o_r = "";
			std::string publisher = "";
			std::string na_sales = "";
			std::string eu_sales = "";
			std::string other_sales = "";

            std::getline(item_line, name, ',');     
			std::getline(item_line, platform, ','); 
			std::getline(item_line, year_o_r, ',');    
            std::getline(item_line, publisher, ','); 
			if (row_values.size() < row) {
        		row_values.resize(row); // Resize the outer vector
    		}  
			row_values[row-1].push_back(publisher);
			std::getline(item_line, na_sales, ','); 
			row_values[row-1].push_back(na_sales);
			std::getline(item_line, eu_sales, ',');    
			row_values[row-1].push_back(eu_sales);
			std::getline(item_line, other_sales);    
            row_values[row-1].push_back(other_sales);
			
			//to see the time of data insertion time comment out these parts - start
				//for random searches
				// Check if the publisher is already in the vector
                
				if (std::find(publishers.begin(), publishers.end(), publisher) == publishers.end()) {
					//if not add
					publishers.push_back(publisher);
				}
                
				/////////----FIND BESTSELLERS-----/////////////////////
				
				int year = stoi(year_o_r);
				if(year == 1991 && printed1990 == false){
					//print max sales
					temp_RBtree.find_best_seller();
					print_best_sellers(1990, temp_RBtree.best_seller);
					printed1990 = true;
				}else if(year == 2001 && printed2000 == false){
					//print max sales
					temp_RBtree.find_best_seller();
					print_best_sellers(2000, temp_RBtree.best_seller);
					printed2000 = true;
				}else if(year == 2011 && printed2010 == false){
					//print max sales
					temp_RBtree.find_best_seller();
					print_best_sellers(2010, temp_RBtree.best_seller);
					printed2010 = true;
				}else if(year == 2020 && printed2020 == false){
					//insert node to tree
					temp_RBtree.insertValue(row_values[row - 1]);
					//print max sales
					temp_RBtree.find_best_seller();
					print_best_sellers(2020, temp_RBtree.best_seller);
					printed2020 = true;
					return temp_RBtree;
				}
				
				/////////----FIND BESTSELLERS END---///////////////////
			//----------------------------------------------------------- end
			// Insert into the tree
				
			temp_RBtree.insertValue(row_values[row - 1]);
			
			row++;
        }
        
	}
    return temp_RBtree;
}

////////////////////////////////////////////
//----------------- MAIN -----------------//
////////////////////////////////////////////
//to search random publishers
void random_search(RB_tree, int);
int main(int argc, char* argv[]){
    // Fill this function.
	string fname = argv[1];	
    
    //---------------data insertion---------------------------
	auto start = std::chrono::high_resolution_clock::now();
    RB_tree RBtree = generate_RBT_tree_from_csv(fname);
	auto end = std::chrono::high_resolution_clock::now();
	auto duration_us = std::chrono::duration_cast<std::chrono::microseconds>(end - start).count();
    std::cout << "Execution time for data_insertion: " << duration_us << " microseconds" << std::endl;

    //---------------------preorder of the tree
    RBtree.preorder();
    

    //---------------------random search-----------------------
	random_search(RBtree, publishers.size());
    
    //----------------generate and search tree from ordered csv
    ordercsv(fname);
    RB_tree orderedRBtree = generate_RBT_tree_from_csv("ordered_data.csv");
    random_search(orderedRBtree, publishers.size());
    
	return EXIT_SUCCESS;
}


/////////////////// Node ///////////////////

Node::Node(publisher key){
	this->key = key;
    this->color = 1; // "RED";
	this->parent = NULL;
	this->left = NULL;
	this->right = NULL;
}

/////////////////// RB-Tree ///////////////////
Node* RB_tree::get_root(){

    // Fill this function.

    return this->root;
}

Node* RB_tree::RB_insert(Node* root, Node* ptr){

    Node* parent = nullptr;
    Node* temp = root;

    while (temp != nullptr) {
        parent = temp;
        //if found update values
        if (ptr->key.name == temp->key.name) {
            temp->key.na_sales += ptr->key.na_sales;
            temp->key.eu_sales += ptr->key.eu_sales;
            temp->key.others_sales += ptr->key.others_sales;
            
            return root;

        } else if (ptr->key.name < temp->key.name) {
            temp = temp->left;
        } else {
            temp = temp->right;
        }
    }

    
    //parent of the new node
    ptr->parent = parent;

    // Insert the new node
    if (parent == NULL) {
        //tree empty
        this->root = ptr;
    } else if (ptr->key.name < parent->key.name) {
        parent->left = ptr;
    } else {
        parent->right = ptr;
    }
    ptr->left = NULL;
    ptr->right = NULL;
    ptr->color = 1;
    RB_insert_fixup(ptr);
    return this->root;
  

}

void RB_tree::insertValue(vector<string> n) {
    
    // Fill this function.

    //define a new publiser
	publisher new_publisher;
    new_publisher.name = n[0];            
    new_publisher.na_sales = stod(n[1]);  
    new_publisher.eu_sales = stod(n[2]);  
    new_publisher.others_sales = stod(n[3]); 

    // Create a new node for this publisher
    Node* new_node = new Node(new_publisher);

    // Insert the node into the BST
    root = RB_insert(this->root, new_node);
	return;
}
void RB_tree::RB_left_rotate(Node *ptr){
    // Fill this function.
    
    Node* temp = ptr->right;
    ptr->right = temp->left;

    if(temp->left != nullptr){
        temp->left->parent = ptr;
    }
    temp->parent = ptr->parent;

    if(ptr->parent == nullptr){
        this->root = temp;
    }else if(ptr == ptr->parent->left){
        ptr->parent->left = temp;
    }else{
        ptr->parent->right = temp;
    }

    temp->left = ptr;
    ptr->parent = temp;
    
}

void RB_tree::RB_right_rotate(Node *ptr){

    // Fill this function.

    Node* temp = ptr->left;
    ptr->left = temp->right;

    if (temp->right != nullptr) {
        temp->right->parent = ptr;
    }

    temp->parent = ptr->parent;

    if (ptr->parent == nullptr) {
        this->root = temp; 
    } else if (ptr == ptr->parent->left) {
        ptr->parent->left = temp;
    } else {
        ptr->parent->right = temp; 
    }

    temp->right = ptr;
    ptr->parent = temp;

}

void RB_tree::RB_insert_fixup(Node *ptr) {
    while (ptr->parent != nullptr && ptr->parent->color == 1) { //parent is red
        if (ptr->parent == ptr->parent->parent->left) {
            // Case 1 - Uncle  red
            Node* uncle = ptr->parent->parent->right;
            if (uncle != nullptr && uncle->color == 1) {
                // Recoloring case
                ptr->parent->color = 0;
                uncle->color = 0;
                ptr->parent->parent->color = 1;
                ptr = ptr->parent->parent; 
            } else {
                // Case 2 - ptr is on the right of its parent
                if (ptr == ptr->parent->right) {
                    ptr = ptr->parent;
                    RB_left_rotate(ptr);  // Left rotate the parent
                }
                // Case 3 - Recoloring and rotation
                ptr->parent->color = 0;
                ptr->parent->parent->color = 1;
                RB_right_rotate(ptr->parent->parent);  // Right rotate grandparent
            }
        }else{ 
            Node* uncle = ptr->parent->parent->left;
            if (uncle != nullptr && uncle->color == 1) {
                // Recoloring case
                ptr->parent->color = 0;
                uncle->color = 0;
                ptr->parent->parent->color = 1;
                ptr = ptr->parent->parent;  
            } else {
                // Case 2 - ptr is on the left of its parent
                if (ptr == ptr->parent->left) {
                    ptr = ptr->parent;
                    RB_right_rotate(ptr);  
                }
                // Case 3 - Recoloring and rotation
                ptr->parent->color = 0;
                ptr->parent->parent->color = 1;
                RB_left_rotate(ptr->parent->parent);  
            }
        }
        
    }

    // root is black
    root->color = 0;
    
}

void RB_tree::preorder(){

    // Fill this function.
    actual_preorder(root, "");
    
}

void RB_tree::actual_preorder(Node* node, string depht){
    if (node == nullptr) {
        return;  
    }

    tree_deep_stack.push(depht);
    // do the operations
    cout << tree_deep_stack.top()
         << "(" << (node->color == 1 ? "RED" : "BLACK") << ")"
         << node->key.name << endl;

    // Recurs left
    depht += "-"; 
    actual_preorder(node->left, depht);

    // Recurs right 
    actual_preorder(node->right,depht);

    tree_deep_stack.pop();
}

void RB_tree::preorder_for_bestseller(Node* node){
	if (node == nullptr)
        return;

    // Deal with the node
	if(node->key.na_sales >= best_seller[0]->na_sales){
		best_seller[0] = &node->key;
	}
	if(node->key.eu_sales >= best_seller[1]->eu_sales){
		best_seller[1] = &node->key;
	}
	if(node->key.others_sales >= best_seller[2]->others_sales){
		best_seller[2] = &node->key;
	}

    // Recur on left subtree
    preorder_for_bestseller(node->left);

    // Recur on right subtree
    preorder_for_bestseller(node->right);
}
void RB_tree::find_best_seller(){
	// Fill this function.
	//find the best seller from the current tree whenever this function is called
	//store it at best_seller array 

	//initially best sellers are 0
	publisher new_publisher;
	new_publisher.name = "default";
	new_publisher.eu_sales = 0;
	new_publisher.na_sales = 0;
	new_publisher.others_sales = 0;
	best_seller[0] = &new_publisher;
	best_seller[1] = &new_publisher;
	best_seller[2] = &new_publisher;

	//use preorder to go over all of the tree and compare each sale
	preorder_for_bestseller(root);
	return;
}


RB_tree::RB_tree(){
	this->root = NULL;
    this->best_seller[0] = NULL;
    this->best_seller[1] = NULL;
    this->best_seller[2] = NULL;
}

RB_tree::~RB_tree(){
}

Node* RB_tree::find_publisher(string publisher_name){
	if(root == NULL){
		cout << "Empty Tree." << endl;
		return NULL;
	}

	Node* temp = root;
	while(temp != NULL && temp->key.name != publisher_name){
		if(publisher_name > temp->key.name){
			temp = temp->right;
		}else if(publisher_name < temp->key.name){
			temp = temp->left;
		}
	}
	if(temp != NULL && temp->key.name == publisher_name){
		cout << "Publisher "<< publisher_name << " found." <<endl;
		return temp;
	}else{
		cout << "Publisher "<< publisher_name << " does not exist." <<endl;
		return NULL;
	}
	

}

void ordercsv(string file_name){
    std::ifstream file(file_name);
    std::string line;

    if (!file.is_open()) {
        std::cout << "Error::Can not open the file " << file_name << std::endl;
    }else{
        //1-write the first line to the ordered_data_csv
        std::ofstream output_file("ordered_data.csv");
        if (!output_file.is_open()) {
            std::cout << "Error::Can not open the output file 'ordered_data.csv'" << std::endl;
            return;
        }
        std::getline(file, line); //first line
        output_file << line << "\n";

        //start reading
		int row = 1;
        //2- read the row values into the vector
		vector<vector<string>> row_values;
        while(std::getline(file, line)){
            std::stringstream item_line(line);

            std::string name = "";                   
            std::string platform = "";
			std::string year_o_r = "";
			std::string publisher = "";
			std::string na_sales = "";
			std::string eu_sales = "";
			std::string other_sales = "";

            if (row_values.size() < row) {
        		row_values.resize(row); // Resize the outer vector
    		} 
            std::getline(item_line, name, ',');    
            if (!name.empty() && name[0] == ' ') {
                name.erase(0, 1); // Remove the space from first few lines
            } 
            row_values[row-1].push_back(name);
			std::getline(item_line, platform, ','); 
            row_values[row-1].push_back(platform);
			std::getline(item_line, year_o_r, ',');  
            row_values[row-1].push_back(year_o_r);  
            std::getline(item_line, publisher, ','); 
			row_values[row-1].push_back(publisher);
			std::getline(item_line, na_sales, ','); 
			row_values[row-1].push_back(na_sales);
			std::getline(item_line, eu_sales, ',');    
			row_values[row-1].push_back(eu_sales);
			std::getline(item_line, other_sales);    
            row_values[row-1].push_back(other_sales);
			
			row++;
        }
        //3-sort the values
        std::sort(row_values.begin(), row_values.end(),
        [](const std::vector<std::string>& a, const std::vector<std::string>& b) {
            return a[0] < b[0]; // Compare the 0th index strings
        });
        //4-write the values to csv
        for (const auto& row : row_values) {
            for (size_t i = 0; i < row.size(); ++i) {
                output_file << row[i];
                if (i < row.size() - 1) {
                    output_file << ",";
                }
            }
            output_file << "\n";
        }

        std::cout << "Data sorted and written to 'ordered_data.csv' successfully." << std::endl;

        // Close files
        file.close();
        output_file.close();
    }
}

void random_search(RB_tree tree, int size){
	//cout << publishers.size(); // 573
	// Create a random number 
    std::random_device rd;  
    std::mt19937 gen(rd()); 
    std::uniform_int_distribution<> dist(0, 573); 
    double avg_time_bst = 0;
	for(int i = 0; i < 50; i++){
		int random_number = dist(gen);
		auto start = std::chrono::high_resolution_clock::now();
		tree.find_publisher(publishers[random_number]);
		auto end = std::chrono::high_resolution_clock::now();
		auto duration_ns = std::chrono::duration_cast<std::chrono::nanoseconds>(end - start).count();
		avg_time_bst += duration_ns;
    	std::cout << "Execution time for red-black tree search: " << duration_ns << " nanoseconds" << std::endl;
	}

	avg_time_bst = avg_time_bst / 50;
	cout << "Average time for red-black tree search: " << avg_time_bst << " nanoseconds" << std::endl;
	
}