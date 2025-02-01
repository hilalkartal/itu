#include <iostream>
#include <vector>
#include <fstream>
#include <map>
#include <queue>
using namespace std;

struct Node {
    string MID;
    vector<Node*> adj;
    vector<string> relation;
};

map<string, Node*> graph_map = {};

//map to store MID's human readable names
map<string, string> MID_names = {};

void HelloNeighbour(const string center_MID){

    auto it = graph_map.find(center_MID);
    if (it == graph_map.end()) {
        cout << "MID is not in the graph." << endl;
        return;
    }
    
    Node* given_MID = it->second;
    
    cout << given_MID->adj.size() <<" neighbours" <<endl;
    
    for(auto it = given_MID->adj.begin(); it != given_MID->adj.end(); ++it){
        Node* neigbour = *it;
        cout << neigbour->MID <<" " << MID_names[neigbour->MID] << endl;
    }

    return;
}

//to calculate degrees
int nodeDegree(Node* vertice){
    int degree = 0;
    for(auto neighbour : vertice->adj){
        degree++;
    }
    return degree;
}

void ShorstestPath(string MID1, string MID2){
    //iterators for the map
    auto it1 = graph_map.find(MID1);
    auto it2 = graph_map.find(MID2);
    //find the MID's in the graph
    if (it1 == graph_map.end() || it2 == graph_map.end()) {
        cout << "MID is not in the graph." << endl;
        return;
    }
    //start and end nodes
    Node* start = it1->second;
    Node* end = it2->second;
    //BFS
    queue<Node*> q;
    map<Node*, bool> visited;
    map<Node*, Node*> parent;
    q.push(start);
    visited[start] = true;
    while (!q.empty()) {
        Node* current = q.front();
        q.pop();
        if (current == end) {
            break;
        }
        for (int i = 0; i < current->adj.size(); i++) {
            Node* neighbour = current->adj[i];
            if (!visited[neighbour]) {
                visited[neighbour] = true;
                parent[neighbour] = current;
                q.push(neighbour);
            }
        }
    }
    if (visited[end]) {
        vector<Node*> path;
        Node* current = end;
        while (current != start) {
            path.push_back(current);
            current = parent[current];
        }
        path.push_back(start);
        cout << "Shortest path between " << MID1 <<" ("<<MID_names[MID1] <<") and " << MID2 <<" ("<< MID_names[MID2] <<") is " << path.size()-1 << " edges." << endl;
        cout << "Path: ";
        for (int i = path.size()-1; i >= 0; i--) {
            cout << path[i]->MID << " (" << MID_names[path[i]->MID] << ")";
            if (i != 0) {
                cout << " -> ";
            }
        }
        cout << endl;
    } else {
        cout << "There is no path between " << MID1 << " and " << MID2 << "." << endl;
    }
    return;
}

int main(int argc, char* argv[])
{ 
    //ifstream infile("../include/freebase.tsv");
    //original
    ifstream infile("freebase.tsv");
    string line;
    while (getline(infile, line))
    {
        string ent1 = line.substr(0, line.find("\t"));
        string remain = line.substr(line.find("\t")+1,line.length()-ent1.length());
        string relationship = remain.substr(0, remain.find("\t"));
        remain = remain.substr(remain.find("\t")+1, remain.length()-relationship.length());
        string ent2 = remain.substr(0, remain.find("\r"));

        Node* ent1_node, *ent2_node;

        if (graph_map.find(ent1) == graph_map.end()) {
            ent1_node = new Node;
            ent1_node->MID = ent1;
            graph_map[ent1] = ent1_node;
        } else {
            ent1_node = graph_map[ent1];
        }

        if (graph_map.find(ent2) == graph_map.end()) {
            ent2_node = new Node;
            ent2_node->MID = ent2;
            graph_map[ent2] = ent2_node;
        } else {
            ent2_node = graph_map[ent2];
        }

        ent1_node->adj.push_back(ent2_node);
        ent1_node->relation.push_back(relationship);

        ent2_node->adj.push_back(ent1_node);
        ent2_node->relation.push_back(relationship);
    }    


    //ifstream infile2("../include/mid2name.tsv");
    //original
    ifstream infile2("mid2name.tsv");
    while (getline(infile2, line))
    {
        string MID = line.substr(0, line.find("\t"));
        string remain = line.substr(line.find("\t")+1,line.length()-MID.length());
        string name = remain.substr(0, remain.find("\r"));

        //add the human readable names to the MID_names map.
        if (MID_names.find(MID) == MID_names.end()) {
            MID_names[MID] = name;
        }    
 
    }

    if(argc == 3){
        cout << "Part 1: " << endl;
        string MID = argv[2];
        HelloNeighbour(MID);
    }

    else if(argc == 2){
        cout << "Part 2: " << endl;
        //this priorty queue stores pairs: int and node
        //int value is the degrees and queue will be ordered according to them.
        //by default they are ordered from biggest to smallest.
        priority_queue<std::pair<int,Node*>> max_cent;
        for(auto vertice: graph_map){
            max_cent.push({nodeDegree(vertice.second),vertice.second});
        }
        cout << "Ten most central nodes:" <<endl;
        for(int i = 0; i < 10; i++){
            cout << "Vertice: "<<max_cent.top().second->MID << " degree: " << max_cent.top().first <<  endl;
            max_cent.pop();
        }
        cout << endl;
    }
   
    else if(argc == 4){
        cout << "Part 3: " << endl;
        string MID1 = argv[2];
        string MID2 = argv[3];
        ShorstestPath(MID1,MID2); 
    }
    
    return 0;
}