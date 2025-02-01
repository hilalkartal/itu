#include "methods.h"

std::vector<Item> countingSort(std::vector<Item>& items, const std::string& attribute, bool ascending)
{
    std::vector<Item> output_array(items.size());
    if(ascending == true){
        if(attribute == "age"){
            //get the size for index_array
            int index_array_size = getMax(items, "age");

            //initialize a vector of size "index_array_size + 1" with all the values 0
            std::vector<int> index_array(index_array_size + 1, 0);
            
            //count each value and add them to index_array 
            for(Item item: items){
                index_array[item.age]++;
            }
            //add (i) + (i+1) to (i+1) at index_array
            for(int i = 0; i < index_array.size() - 2; i++){
                index_array[i+1] = index_array[i] + index_array[i+1];
            }
            //shift to right by one
            for(int j = index_array.size() - 1; j > 0; j--){
                index_array[j] = index_array[j - 1];
            } 
            index_array[0] = 0;
            //index_array is now ready
            //arrange the output array
            //read from input array -> check its place at index array 
            //-> place to the proper place at output array -> increment the index at index array
            for(Item item : items){
                int index = index_array[item.age];
                output_array[index] = item;
                index_array[item.age]++;
            }
        }
        else if(attribute == "type"){
            //get the size for index_array
            int index_array_size = getMax(items, "type");

            //initialize a vector of size "index_array_size + 1" with all the values 0
            std::vector<int> index_array(index_array_size + 1, 0);
            
            //count each value and add them to index_array 
            for(Item item: items){
                index_array[item.type]++;
            }
            //add (i) + (i+1) to (i+1) at index_array
            for(int i = 0; i < index_array.size() - 2; i++){
                index_array[i+1] = index_array[i] + index_array[i+1];
            }
            //shift to right by one
            for(int j = index_array.size() - 1; j > 0; j--){
                index_array[j] = index_array[j - 1];
            } 
            index_array[0] = 0;
            //index_array is now ready
            //arrange the output array
            //read from input array -> check its place at index array 
            //-> place to the proper place at output array -> increment the index at index array
            for(Item item : items){
                int index = index_array[item.type];
                output_array[index] = item;
                index_array[item.type]++;
            }
        }
        else if(attribute == "origin"){
            //get the size for index_array
            int index_array_size = getMax(items, "origin");

            //initialize a vector of size "index_array_size + 1" with all the values 0
            std::vector<int> index_array(index_array_size + 1, 0);
            
            //count each value and add them to index_array 
            for(Item item: items){
                index_array[item.origin]++;
            }
            //add (i) + (i+1) to (i+1) at index_array
            for(int i = 0; i < index_array.size() - 2; i++){
                index_array[i+1] = index_array[i] + index_array[i+1];
            }
            //shift to right by one
            for(int j = index_array.size() - 1; j > 0; j--){
                index_array[j] = index_array[j - 1];
            } 
            index_array[0] = 0;
            //index_array is now ready
            //arrange the output array
            //read from input array -> check its place at index array 
            //-> place to the proper place at output array -> increment the index at index array
            for(Item item : items){
                int index = index_array[item.origin];
                output_array[index] = item;
                index_array[item.origin]++;
            }
        }
        else if(attribute == "rarityScore"){
            //get the size for index_array
            int index_array_size = getMax(items, "rarityScore");

            //initialize a vector of size "index_array_size + 1" with all the values 0
            std::vector<int> index_array(index_array_size + 1, 0);
            
            //count each value and add them to index_array 
            for(Item item: items){
                index_array[item.rarityScore]++;
            }
            //add (i) + (i+1) to (i+1) at index_array
            for(int i = 0; i < index_array.size() - 2; i++){
                index_array[i+1] = index_array[i] + index_array[i+1];
            }
            //shift to right by one
            for(int j = index_array.size() - 1; j > 0; j--){
                index_array[j] = index_array[j - 1];
            } 
            index_array[0] = 0;
            //index_array is now ready
            //arrange the output array
            //read from input array -> check its place at index array 
            //-> place to the proper place at output array -> increment the index at index array
            for(Item item : items){
                int index = index_array[item.rarityScore];
                output_array[index] = item;
                index_array[item.rarityScore]++;
            }
        }        
    }else if(ascending == false){
        if(attribute == "age"){
            //get the size for index_array
            int index_array_size = getMax(items, "age");

            //initialize a vector of size "index_array_size + 1" with all the values 0
            std::vector<int> index_array(index_array_size + 1, 0);
            
            //count each value and add them to index_array 
            for(Item item: items){
                index_array[item.age]++;
            }
            //add (i) + (i+1) to (i+1) at index_array
            for(int i = 0; i < index_array.size() - 2; i++){
                index_array[i+1] = index_array[i] + index_array[i+1];
            }
            //shift to right by one
            for(int j = index_array.size() - 1; j > 0; j--){
                index_array[j] = index_array[j - 1];
            } 
            index_array[0] = 0;
            //index_array is now ready
            //arrange the output array
            //read from input array -> check its place at index array 
            //-> place to the proper place at output array -> increment the index at index array
            for(Item item : items){
                int index = index_array[item.age];
                output_array[(output_array.size() - 1) - index] = item;
                index_array[item.age]++;
            }
        }
        else if(attribute == "type"){
            //get the size for index_array
            int index_array_size = getMax(items, "type");

            //initialize a vector of size "index_array_size + 1" with all the values 0
            std::vector<int> index_array(index_array_size + 1, 0);
            
            //count each value and add them to index_array 
            for(Item item: items){
                index_array[item.type]++;
            }
            //add (i) + (i+1) to (i+1) at index_array
            for(int i = 0; i < index_array.size() - 2; i++){
                index_array[i+1] = index_array[i] + index_array[i+1];
            }
            //shift to right by one
            for(int j = index_array.size() - 1; j > 0; j--){
                index_array[j] = index_array[j - 1];
            } 
            index_array[0] = 0;
            //index_array is now ready
            //arrange the output array
            //read from input array -> check its place at index array 
            //-> place to the proper place at output array -> increment the index at index array
            for(Item item : items){
                int index = index_array[item.type];
                output_array[(output_array.size() - 1) - index] = item;
                index_array[item.type]++;
            }
        }
        else if(attribute == "origin"){
            //get the size for index_array
            int index_array_size = getMax(items, "origin");

            //initialize a vector of size "index_array_size + 1" with all the values 0
            std::vector<int> index_array(index_array_size + 1, 0);
            
            //count each value and add them to index_array 
            for(Item item: items){
                index_array[item.origin]++;
            }
            //add (i) + (i+1) to (i+1) at index_array
            for(int i = 0; i < index_array.size() - 2; i++){
                index_array[i+1] = index_array[i] + index_array[i+1];
            }
            //shift to right by one
            for(int j = index_array.size() - 1; j > 0; j--){
                index_array[j] = index_array[j - 1];
            } 
            index_array[0] = 0;
            //index_array is now ready
            //arrange the output array
            //read from input array -> check its place at index array 
            //-> place to the proper place at output array -> increment the index at index array
            for(Item item : items){
                int index = index_array[item.origin];
                output_array[(output_array.size() - 1) - index] = item;
                index_array[item.origin]++;
            }
        }
        else if(attribute == "rarityScore"){
            //get the size for index_array
            int index_array_size = getMax(items, "rarityScore");

            //initialize a vector of size "index_array_size + 1" with all the values 0
            std::vector<int> index_array(index_array_size + 1, 0);
            
            //count each value and add them to index_array 
            for(Item item: items){
                index_array[item.rarityScore]++;
            }
            //add (i) + (i+1) to (i+1) at index_array
            for(int i = 0; i < index_array.size() - 2; i++){
                index_array[i+1] = index_array[i] + index_array[i+1];
            }
            //shift to right by one
            for(int j = index_array.size() - 1; j > 0; j--){
                index_array[j] = index_array[j - 1];
            } 
            index_array[0] = 0;
            //index_array is now ready
            //arrange the output array
            //read from input array -> check its place at index array 
            //-> place to the proper place at output array -> increment the index at index array
            for(Item item : items){
                int index = index_array[item.rarityScore];
                output_array[(output_array.size() - 1) - index] = item;
                index_array[item.rarityScore]++;
            }
        }  
    }
    
    return output_array;
}

// Function to heapify a subtree rooted with node i in the array of items
void heapify(std::vector<Item>& items, int n, int i, bool descending)
{
    if(descending == false){        //max heap
        int left_child = 2*i + 1;
        int right_child = 2*i + 2;
        int biggest = i;
        //if left child is bigger than root, swap root left child
        if(left_child < n && items[left_child].rarityScore > items[biggest].rarityScore){
            biggest = left_child;
        }

        //if right child is bigger than current biggest, swap the current biggest with right child 
        if(right_child < n && items[right_child].rarityScore > items[biggest].rarityScore){
            biggest = right_child;
        }

        //if root chnaged, do the actual swapping and continue to heapfiy with changed subtree
        if (biggest != i) {
        std::swap(items[i], items[biggest]);
        heapify(items, n, biggest, descending);
        }

    }else if(descending == true){      //min heap
        int left_child = 2*i + 1;
        int right_child = 2*i + 2;
        int smallest = i;
        //if left child is smaleer than root, swap root left child
        if(left_child < n && items[left_child].rarityScore < items[smallest].rarityScore){
            smallest = left_child;
        }

        //if right child is smaller than current smallest, swap the current smallest with right child 
        if(right_child < n && items[right_child].rarityScore < items[smallest].rarityScore){
            smallest = right_child;
        }

        //if root chnaged, do the actual swapping and continue to heapfiy with changed subtree
        if (smallest != i) {
        std::swap(items[i], items[smallest]);
        heapify(items, n, smallest, descending);
        }
    }
}

// Function to perform heap sort on rarityScore scores of items
std::vector<Item> heapSortByRarity(std::vector<Item>& items, bool descending)
{
    //get the heap
    //for loop beacuse we start from middle of the array do heapfiy at right side
    //and move up, do heapify again
    for (int i = items.size() / 2 - 1; i >= 0; i--) {
        heapify(items, items.size(), i, descending);
    }

    //move the root to end 
    for (int i = items.size() - 1; i > 0; i--) {
        std::swap(items[0], items[i]);

        //do heap again to fix the heap 
        heapify(items, i, 0, descending);
    }

    return items;
    
}
