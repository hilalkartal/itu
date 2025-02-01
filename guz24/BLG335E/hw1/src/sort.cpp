#include "tweet.h"

void bubbleSort(std::vector<Tweet>& tweets, const std::string& sortBy, bool ascending) 
{   
    //check for ascending or descending
    if(ascending == true){
        //check sorting value
        if(sortBy == "tweetID"){
            int i, j;
            Tweet temp;
            for(int i = (tweets.size()-1); i >= 0; i--){
                for(int j = 1; j <= i; j++){
                    if(tweets[j-1].tweetID > tweets[j].tweetID){
                        temp = tweets[j-1];
                        tweets[j-1] = tweets[j];
                        tweets[j] = temp;
                    }
                }
            }

        }else if(sortBy == "retweetCount"){
            int i, j;
            Tweet temp;
            for(int i = (tweets.size()-1); i >= 0; i--){
                for(int j = 1; j <= i; j++){
                    if(tweets[j-1].retweetCount > tweets[j].retweetCount){
                        temp = tweets[j-1];
                        tweets[j-1] = tweets[j];
                        tweets[j] = temp;
                    }
                }
            }

        }else if(sortBy == "favoriteCount"){
            int i, j;
            Tweet temp;
            for(int i = (tweets.size()-1); i >= 0; i--){
                for(int j = 1; j <= i; j++){
                    if(tweets[j-1].favoriteCount > tweets[j].favoriteCount){
                        temp = tweets[j-1];
                        tweets[j-1] = tweets[j];
                        tweets[j] = temp;
                    }
                }
            }
        }

        
    }else if(ascending == false){
        //check sorting value
        if(sortBy == "tweetID"){
            int i, j;
            Tweet temp;
            for(int i = (tweets.size()-1); i >= 0; i--){
                for(int j = 1; j <= i; j++){ 
                    if(tweets[j-1].tweetID < tweets[j].tweetID){
                        temp = tweets[j-1];
                        tweets[j-1] = tweets[j];
                        tweets[j] = temp;
                    }
                }
            }
        }else if(sortBy == "retweetCount"){
            int i, j;
            Tweet temp;
            for(int i = (tweets.size()-1); i >= 0; i--){
                for(int j = 1; j <= i; j++){
                    if(tweets[j-1].retweetCount < tweets[j].retweetCount){
                        temp = tweets[j-1];
                        tweets[j-1] = tweets[j];
                        tweets[j] = temp;
                    }
                }
            }
        }else if(sortBy == "favoriteCount"){
            int i, j;
            Tweet temp;
            for(int i = (tweets.size()-1); i >= 0; i--){
                for(int j = 1; j <= i; j++){
                    if(tweets[j-1].favoriteCount < tweets[j].favoriteCount){
                        temp = tweets[j-1];
                        tweets[j-1] = tweets[j];
                        tweets[j] = temp;
                    }
                }
            } 
        }
    }
}

void insertionSort(std::vector<Tweet>& tweets, const std::string& sortBy, bool ascending) 
{
    //check for ascending or descending
    if(ascending == true){
        if(sortBy == "tweetID"){
            for(int i = 1; i <= (tweets.size() - 1); i++){
                int j = i;
                while(j > 0 && tweets[j-1].tweetID > tweets[j].tweetID){
                    Tweet temp = tweets[j];
                    tweets[j] = tweets[j-1];
                    tweets[j-1] = temp;
                    j = j-1;
                } 
            }
        }else if(sortBy == "retweetCount"){
            for(int i = 1; i <= (tweets.size() - 1); i++){
                int j = i;
                while(j > 0 && tweets[j-1].retweetCount > tweets[j].retweetCount){
                    Tweet temp = tweets[j];
                    tweets[j] = tweets[j-1];
                    tweets[j-1] = temp;
                    j = j-1;
                } 
            }
        }else if(sortBy == "favoriteCount"){
            for(int i = 1; i <= (tweets.size() - 1); i++){
                int j = i;
                while(j > 0 && tweets[j-1].favoriteCount > tweets[j].favoriteCount){
                    Tweet temp = tweets[j];
                    tweets[j] = tweets[j-1];
                    tweets[j-1] = temp;
                    j = j-1;
                } 
            }
        }
    

    }else if(ascending == false){
        if(sortBy == "tweetID"){
            for(int i = 1; i <= (tweets.size() - 1); i++){
                int j = i;
                while(j > 0 && tweets[j-1].tweetID < tweets[j].tweetID){
                    Tweet temp = tweets[j];
                    tweets[j] = tweets[j-1];
                    tweets[j-1] = temp;
                    j = j-1;
                } 
            }
        }else if(sortBy == "retweetCount"){
            for(int i = 1; i <= (tweets.size() - 1); i++){
                int j = i;
                while(j > 0 && tweets[j-1].retweetCount < tweets[j].retweetCount){
                    Tweet temp = tweets[j];
                    tweets[j] = tweets[j-1];
                    tweets[j-1] = temp;
                    j = j-1;
                } 
            }
        }else if(sortBy == "favoriteCount"){
            for(int i = 1; i <= (tweets.size() - 1); i++){
                int j = i;
                while(j > 0 && tweets[j-1].favoriteCount < tweets[j].favoriteCount){
                    Tweet temp = tweets[j];
                    tweets[j] = tweets[j-1];
                    tweets[j-1] = temp;
                    j = j-1;
                } 
            }
        }
    }

}

void merge(std::vector<Tweet>& tweets, int left, int mid, int right, const std::string& sortBy, bool ascending) {
    //make temp vectors for dividing
    
    std::vector<Tweet> temp1;   //////////////////
    std::vector<Tweet> temp2;

    //pushback the first half to first temp
    for(int i = 0; i <= (mid - left) ; i++){
        //temp1[i] = tweets[left + i];
        temp1.push_back(tweets[left + i]);
    }

    //pushback second half to second temp
    for(int j = 0; j < (right - mid) ; j++){
        //temp2[j] = tweets[mid + 1 + j];
        temp2.push_back(tweets[mid + 1 + j]);
    }

    int i = 0;
    int j = 0;
    int k = left;
    //now the merge starts
    //have to check sortBy and ascending

    if(ascending == true){
        if(sortBy == "tweetID"){
            while(i < temp1.size() && j < temp2.size()){
                if(temp1[i].tweetID <= temp2[j].tweetID){
                    tweets[k] = temp1[i];
                    i++;
                    k++;
                }else{
                    tweets[k] = temp2[j];
                    j++;
                    k++;
                }
            }

            //if temp1 is over copy temp2
            if(i >= temp1.size()){
                while (j < temp2.size()) {
                    tweets[k++] = temp2[j++];
                }
            }
            //if temp2 is over copy temp1
            if(j >= temp2.size()){
                while (i < temp1.size()) {
                    tweets[k++] = temp1[i++];
                }
            }
        }else if(sortBy == "retweetCount"){
             while(i < temp1.size() && j < temp2.size()){
                if(temp1[i].retweetCount <= temp2[j].retweetCount){
                    tweets[k] = temp1[i];
                    i++;
                    k++;
                }else{
                    tweets[k] = temp2[j];
                    j++;
                    k++;
                }
            }

            //if temp1 is over copy temp2
            if(i >= temp1.size()){
                while (j < temp2.size()) {
                    tweets[k++] = temp2[j++];
                }
            }
            //if temp2 is over copy temp1
            if(j >= temp2.size()){
                while (i < temp1.size()) {
                    tweets[k++] = temp1[i++];
                }
            }
        }else if(sortBy == "favoriteCount"){
            while(i < temp1.size() && j < temp2.size()){
                if(temp1[i].favoriteCount <= temp2[j].favoriteCount){
                    tweets[k] = temp1[i];
                    i++;
                    k++;
                }else{
                    tweets[k] = temp2[j];
                    j++;
                    k++;
                }
            }

            //if temp1 is over copy temp2
            if(i >= temp1.size()){
                while (j < temp2.size()) {
                    tweets[k++] = temp2[j++];
                }
            }
            //if temp2 is over copy temp1
            if(j >= temp2.size()){
                while (i < temp1.size()) {
                    tweets[k++] = temp1[i++];
                }
            }
        }

    }else if(ascending == false){
        if(sortBy == "tweetID"){
            
            while(i < temp1.size() && j < temp2.size()){
                if(temp1[i].tweetID >= temp2[j].tweetID){
                    tweets[k] = temp1[i];
                    i++;
                    k++;
                }else{
                    tweets[k] = temp2[j];
                    j++;
                    k++;
                }
            }

            //if temp1 is over copy temp2
            if(i >= temp1.size()){
                while (j < temp2.size()) {
                    tweets[k++] = temp2[j++];
                }
            }
            //if temp2 is over copy temp1
            if(j >= temp2.size()){
                while (i < temp1.size()) {
                    tweets[k++] = temp1[i++];
                }
            }

        }else if(sortBy == "retweetCount"){
             while(i < temp1.size() && j < temp2.size()){
                if(temp1[i].retweetCount >= temp2[j].retweetCount){
                    tweets[k] = temp1[i];
                    i++;
                    k++;
                }else{
                    tweets[k] = temp2[j];
                    j++;
                    k++;
                }
            }

            //if temp1 is over copy temp2
            if(i >= temp1.size()){
                while (j < temp2.size()) {
                    tweets[k++] = temp2[j++];
                }
            }
            //if temp2 is over copy temp1
            if(j >= temp2.size()){
                while (i < temp1.size()) {
                    tweets[k++] = temp1[i++];
                }
            }
        }else if(sortBy == "favoriteCount"){
            while(i < temp1.size() && j < temp2.size()){
                if(temp1[i].favoriteCount >= temp2[j].favoriteCount){
                    tweets[k] = temp1[i];
                    i++;
                    k++;
                }else{
                    tweets[k] = temp2[j];
                    j++;
                    k++;
                }
            }

            //if temp1 is over copy temp2
            if(i >= temp1.size()){
                while (j < temp2.size()) {
                    tweets[k++] = temp2[j++];
                }
            }
            //if temp2 is over copy temp1
            if(j >= temp2.size()){
                while (i < temp1.size()) {
                    tweets[k++] = temp1[i++];
                }
            }
        }
    }
}

void mergeSort(std::vector<Tweet>& tweets, int left, int right, const std::string& sortBy, bool ascending) {
        if(left < right){
            int mid = (left + right) / 2 ;
            mergeSort(tweets, left, mid, sortBy, ascending);
            mergeSort(tweets, (mid + 1), right, sortBy, ascending);
            merge(tweets, left, mid, right, sortBy, ascending);
        }
}