#include <iostream>

using namespace std;

template <typename T>
struct Stack{
    T stack[100];
    //T* top = NULL;
    static int count;
    
    //functions
    bool empty();
    int size();
    T top();
    void push(T);
    void pop();
};

template<typename T>
int Stack<T>::count = 0;

template<typename T>
bool Stack<T>::empty(){
    if(count == 0){
        return true;
    }
    else{
        return false;
    }
}

template<typename T>
int Stack<T>::size(){
    return count;
}

template<typename T>
T Stack<T>::top(){
    if(count == 0){
        return -1;
    }else{
        T top_element = stack[count -1];
        return top_element;
    }
}

template<typename T>
void Stack<T>::push(T element){
    stack[count] = element;
    count++;
}

template<typename T>
void Stack<T>::pop(){
    if(empty()){
        cout << "stack empty" << endl;
    }else{
        count--;
    } 
}