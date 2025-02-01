#include "tweet.h"

int binarySearch(const std::vector<Tweet>& tweets, long long key, const std::string& sortBy)
{
    int lowerB = 0;
    int upperB = tweets.size() - 1;
    //sortBy conditions (either retweet count or favourite count)
    if(sortBy == "tweetID"){
        while(lowerB <= upperB){
            int mid = lowerB + (upperB - lowerB) / 2 ;
            if(tweets[mid].tweetID < key){
                lowerB = mid + 1;
            }else if(tweets[mid].tweetID > key){
                upperB = mid - 1;
            }else if(tweets[mid].tweetID == key){
                return mid;
            }
        }
    }else if(sortBy == "retweetCount"){
        while(lowerB <= upperB){
            int mid = lowerB + (upperB - lowerB) / 2 ;
            if(tweets[mid].retweetCount < key){
                lowerB = mid + 1;
            }else if(tweets[mid].retweetCount > key){
                upperB = mid - 1;
            }else if(tweets[mid].retweetCount == key){
                return mid;
            }
        }
    }else  if(sortBy == "favoriteCount"){
        while(lowerB <= upperB){
            int mid = lowerB + (upperB - lowerB) / 2 ;
            if(tweets[mid].favoriteCount < key){
                lowerB = mid + 1;
            }else if(tweets[mid].favoriteCount > key){
                upperB = mid - 1;
            }else if(tweets[mid].favoriteCount == key){
                return mid;
            }
        }
    }
    if(lowerB > upperB){
        return -1;      //ERROR.
    }
}

int countAboveThreshold(const std::vector<Tweet>& tweets, const std::string& metric, int threshold) 
{
    int count = 0;
    //sortBy metric
    if(metric == "retweetCount"){
        for(Tweet tweet : tweets){
            if(tweet.retweetCount > threshold){
                count++;
            }
        }
    }else if(metric == "favoriteCount"){
        for(Tweet tweet : tweets){
            if(tweet.favoriteCount > threshold){
                count++;
            }
        }
    }
    return count; 
}