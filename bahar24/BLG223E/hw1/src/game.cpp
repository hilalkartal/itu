#include <stdlib.h>
#include <iostream>
#include <fstream>
#include <string>
#include <cstring>
#include <iterator>

#include "../include/doublelinklist.h"
#include "../include/objects.h"

#include <stack>

using namespace std;

int main()
{   
    GameState first_state;
    first_state.create_init_state();
   
    DoublyList<int> result;     //stack
   
    int state = 0;
    int action = 1;
    int object = 1;
    int prev_state = state;
    state = first_state.advance(action, object);

    result.addFront(state);
    
    while(result.head->data != 12){
        if(first_state.room_id == 0){       // if in the Cell 
            for(action = 1; action <= 6; action++ ){
                for(object = 0; object <= 6; object++){
                    if(result.head->data <= 0){
                        result.removeFront();
                    }
                    
                    state = first_state.advance(action, object);

                    result.addFront(state);
                } 
            }
        }
        else if(first_state.room_id == 1){
            for(action = 1; action <= 6; action++ ){
                for(object = 0; object <= 4; object++){
                    
                    if(result.head->data <= 0){
                        result.removeFront();
                    }
                    
                    prev_state = result.head->data;
                    if(prev_state != 11 && action == 1 && object == 4){
                        object++;
                        state = first_state.advance(action, object);
                    }else{
                        state = first_state.advance(action, object);
                    }

                    result.addFront(state);
                    if(result.head->data <= 0){
                        result.removeFront();
                    }
                } 
            }
        }else if(first_state.room_id == 2){
            for(action = 1; action <= 6; action++ ){
                for(object = 0; object <= 2; object++){
                    if(result.head->data <= 0){
                        result.removeFront();
                    }
                   
                    state = first_state.advance(action, object);
                    
                    result.addFront(state);
                    if(result.head->data <= 0){
                        result.removeFront();
                    }
                } 
            }
        }    
    }
    cout << "Number of steps needed to finish the game: "<<result.elemcount<<endl;
    
    cout <<"Steps: ";
    while (result.elemcount != 0) {
        cout << result.tail->data << " ";
        result.removeBack();
    }
    
    return 0;
}