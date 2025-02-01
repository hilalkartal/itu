#include "tweet.h"
//to time functions
#include <chrono>

int main() 
{

//For TABLE 1.1
std::cout << "For Table 1.1::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::." << std::endl;
    //read the files for BubbleSort
    std::vector<Tweet> tweets_BS = readTweetsFromFile("data/permutations/tweets.csv");
    std::vector<Tweet> tweetsNS_BS = readTweetsFromFile("data/permutations/tweetsNS.csv");
    std::vector<Tweet> tweetsSA_BS = readTweetsFromFile("data/permutations/tweetsSA.csv");
    std::vector<Tweet> tweetsSD_BS = readTweetsFromFile("data/permutations/tweetsSD.csv");

    //read the files for InsertionSort
    std::vector<Tweet> tweets_IS = readTweetsFromFile("data/permutations/tweets.csv");
    std::vector<Tweet> tweetsNS_IS = readTweetsFromFile("data/permutations/tweetsNS.csv");
    std::vector<Tweet> tweetsSA_IS = readTweetsFromFile("data/permutations/tweetsSA.csv");
    std::vector<Tweet> tweetsSD_IS = readTweetsFromFile("data/permutations/tweetsSD.csv");
    //read the files for MergeSort
    std::vector<Tweet> tweets_MS = readTweetsFromFile("data/permutations/tweets.csv");
    std::vector<Tweet> tweetsNS_MS = readTweetsFromFile("data/permutations/tweetsNS.csv");
    std::vector<Tweet> tweetsSA_MS = readTweetsFromFile("data/permutations/tweetsSA.csv");
    std::vector<Tweet> tweetsSD_MS = readTweetsFromFile("data/permutations/tweetsSD.csv");

//For BubbleSort
    std::cout << "------------------- For BubbleSort ------------------------" <<std::endl;

    auto start = std::chrono::high_resolution_clock::now();
    bubbleSort(tweets_BS, "retweetCount", true);
    auto end = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double> duration = end - start;
    std::cout << "Execution time for tweets - retweetCount: " << duration.count() << " seconds" << std::endl;

    start = std::chrono::high_resolution_clock::now();
    bubbleSort(tweetsNS_BS, "retweetCount", true);
    end = std::chrono::high_resolution_clock::now();
    duration = end - start;
    std::cout << "Execution time for tweetsNS - retweetCount: " << duration.count() << " seconds" << std::endl;

    start = std::chrono::high_resolution_clock::now();
    bubbleSort(tweetsSA_BS, "retweetCount", true);
    end = std::chrono::high_resolution_clock::now();
    duration = end - start;
    std::cout << "Execution time for tweetsSA - retweetCount: " << duration.count() << " seconds" << std::endl;

    start = std::chrono::high_resolution_clock::now();
    bubbleSort(tweetsSD_BS, "retweetCount", true);
    end = std::chrono::high_resolution_clock::now();
    duration = end - start;
    std::cout << "Execution time for tweetsSD - retweetCount: " << duration.count() << " seconds" << std::endl;
    
//For InsertionSort
    std::cout << "------------------- For InsertionSort ------------------------" <<std::endl;

    start = std::chrono::high_resolution_clock::now();
    insertionSort(tweets_IS, "retweetCount", true);
    end = std::chrono::high_resolution_clock::now();
    duration = end - start;
    std::cout << "Execution time for tweets - retweetCount: " << duration.count() << " seconds" << std::endl;

    start = std::chrono::high_resolution_clock::now();
    insertionSort(tweetsNS_IS, "retweetCount", true);
    end = std::chrono::high_resolution_clock::now();
    duration = end - start;
    std::cout << "Execution time for tweetsNS - retweetCount: " << duration.count() << " seconds" << std::endl;

    start = std::chrono::high_resolution_clock::now();
    insertionSort(tweetsSA_IS, "retweetCount", true);
    end = std::chrono::high_resolution_clock::now();
    duration = end - start;
    std::cout << "Execution time for tweetsSA - retweetCount: " << duration.count() << " seconds" << std::endl;

    start = std::chrono::high_resolution_clock::now();
    insertionSort(tweetsSD_IS, "retweetCount", true);
    end = std::chrono::high_resolution_clock::now();
    duration = end - start;
    std::cout << "Execution time for tweetsSD - retweetCount: " << duration.count() << " seconds" << std::endl;

//For MergeSort
    std::cout << "------------------- For MergeSort ------------------------" <<std::endl;

    start = std::chrono::high_resolution_clock::now();
    mergeSort(tweets_MS,  0, tweets_MS.size() - 1 ,"retweetCount", true);
    end = std::chrono::high_resolution_clock::now();
    duration = end - start;
    std::cout << "Execution time for tweets - retweetCount: " << duration.count() << " seconds" << std::endl;

    start = std::chrono::high_resolution_clock::now();
    mergeSort(tweetsNS_MS,  0, tweetsNS_MS.size() - 1 ,"retweetCount", true);
    end = std::chrono::high_resolution_clock::now();
    duration = end - start;
    std::cout << "Execution time for tweetsNS - retweetCount: " << duration.count() << " seconds" << std::endl;

    start = std::chrono::high_resolution_clock::now();
    mergeSort(tweetsSA_MS,  0, tweetsSA_MS.size() - 1 ,"retweetCount", true);
    end = std::chrono::high_resolution_clock::now();
    duration = end - start;
    std::cout << "Execution time for tweetsSA - retweetCount: " << duration.count() << " seconds" << std::endl;

    start = std::chrono::high_resolution_clock::now();
    mergeSort(tweetsSD_MS,  0, tweetsSD_MS.size() - 1 ,"retweetCount", true);
    end = std::chrono::high_resolution_clock::now();
    duration = end - start;
    std::cout << "Execution time for tweetsSD - retweetCount: " << duration.count() << " seconds" << std::endl;


//For TABLE 1.2
std::cout << "For Table 1.2::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::." << std::endl;
    //read the files for BubbleSort
    std::vector<Tweet> tweets_BS_5K = readTweetsFromFile("data/sizes/tweets5K.csv");
    std::vector<Tweet> tweetsNS_BS_10K = readTweetsFromFile("data/sizes/tweets10K.csv");
    std::vector<Tweet> tweetsSA_BS_20K = readTweetsFromFile("data/sizes/tweets20K.csv");
    std::vector<Tweet> tweetsSD_BS_30K = readTweetsFromFile("data/sizes/tweets30K.csv");
    std::vector<Tweet> tweetsSD_BS_50K = readTweetsFromFile("data/sizes/tweets50K.csv");
    
    //read the files for InsertionSort
    std::vector<Tweet> tweets_IS_5K = readTweetsFromFile("data/sizes/tweets5K.csv");
    std::vector<Tweet> tweetsNS_IS_10K = readTweetsFromFile("data/sizes/tweets10K.csv");
    std::vector<Tweet> tweetsSA_IS_20K = readTweetsFromFile("data/sizes/tweets20K.csv");
    std::vector<Tweet> tweetsSD_IS_30K = readTweetsFromFile("data/sizes/tweets30K.csv");
    std::vector<Tweet> tweetsSD_IS_50K = readTweetsFromFile("data/sizes/tweets50K.csv");
    
    //read the files for MergeSort
    std::vector<Tweet> tweets_MS_5K = readTweetsFromFile("data/sizes/tweets5K.csv");
    std::vector<Tweet> tweetsNS_MS_10K = readTweetsFromFile("data/sizes/tweets10K.csv");
    std::vector<Tweet> tweetsSA_MS_20K = readTweetsFromFile("data/sizes/tweets20K.csv");
    std::vector<Tweet> tweetsSD_MS_30K = readTweetsFromFile("data/sizes/tweets30K.csv");
    std::vector<Tweet> tweetsSD_MS_50K = readTweetsFromFile("data/sizes/tweets50K.csv");

//BubbleSort
std::cout << "------------------- For BubbleSort ------------------------" <<std::endl;

    start = std::chrono::high_resolution_clock::now();
    bubbleSort(tweets_BS_5K, "retweetCount", true);
    end = std::chrono::high_resolution_clock::now();
    duration = end - start;
    std::cout << "Execution time for tweets5K - retweetCount: " << duration.count() << " seconds" << std::endl;

    start = std::chrono::high_resolution_clock::now();
    bubbleSort(tweetsNS_BS_10K, "retweetCount", true);
    end = std::chrono::high_resolution_clock::now();
    duration = end - start;
    std::cout << "Execution time for tweets10K - retweetCount: " << duration.count() << " seconds" << std::endl;

    start = std::chrono::high_resolution_clock::now();
    bubbleSort(tweetsSA_BS_20K, "retweetCount", true);
    end = std::chrono::high_resolution_clock::now();
    duration = end - start;
    std::cout << "Execution time for tweets20K - retweetCount: " << duration.count() << " seconds" << std::endl;

    start = std::chrono::high_resolution_clock::now();
    bubbleSort(tweetsSD_BS_30K, "retweetCount", true);
    end = std::chrono::high_resolution_clock::now();
    duration = end - start;
    std::cout << "Execution time for tweets30K - retweetCount: " << duration.count() << " seconds" << std::endl;

    start = std::chrono::high_resolution_clock::now();
    bubbleSort(tweetsSD_BS_50K, "retweetCount", true);
    end = std::chrono::high_resolution_clock::now();
    duration = end - start;
    std::cout << "Execution time for tweets50K- retweetCount: " << duration.count() << " seconds" << std::endl;


//InsertionSort
std::cout << "------------------- For InsertionSort ------------------------" <<std::endl;

    start = std::chrono::high_resolution_clock::now();
    insertionSort(tweets_IS_5K, "retweetCount", true);
    end = std::chrono::high_resolution_clock::now();
    duration = end - start;
    std::cout << "Execution time for tweets5K - retweetCount: " << duration.count() << " seconds" << std::endl;

    start = std::chrono::high_resolution_clock::now();
    insertionSort(tweetsNS_IS_10K, "retweetCount", true);
    end = std::chrono::high_resolution_clock::now();
    duration = end - start;
    std::cout << "Execution time for tweets10K - retweetCount: " << duration.count() << " seconds" << std::endl;

    start = std::chrono::high_resolution_clock::now();
    insertionSort(tweetsSA_IS_20K, "retweetCount", true);
    end = std::chrono::high_resolution_clock::now();
    duration = end - start;
    std::cout << "Execution time for tweets20K - retweetCount: " << duration.count() << " seconds" << std::endl;

    start = std::chrono::high_resolution_clock::now();
    insertionSort(tweetsSD_IS_30K, "retweetCount", true);
    end = std::chrono::high_resolution_clock::now();
    duration = end - start;
    std::cout << "Execution time for tweets30K - retweetCount: " << duration.count() << " seconds" << std::endl;

    start = std::chrono::high_resolution_clock::now();
    insertionSort(tweetsSD_IS_50K, "retweetCount", true);
    end = std::chrono::high_resolution_clock::now();
    duration = end - start;
    std::cout << "Execution time for tweets50K- retweetCount: " << duration.count() << " seconds" << std::endl;

//MergeSort
std::cout << "------------------- For MergeSort ------------------------" <<std::endl;

    start = std::chrono::high_resolution_clock::now();
    mergeSort(tweets_IS_5K, 0, tweets_IS_5K.size() - 1 , "retweetCount", true);
    end = std::chrono::high_resolution_clock::now();
    duration = end - start;
    std::cout << "Execution time for tweets5K - retweetCount: " << duration.count() << " seconds" << std::endl;

    start = std::chrono::high_resolution_clock::now();
    mergeSort(tweetsNS_IS_10K,0, tweetsNS_IS_10K.size() - 1 , "retweetCount", true);
    end = std::chrono::high_resolution_clock::now();
    duration = end - start;
    std::cout << "Execution time for tweets10K - retweetCount: " << duration.count() << " seconds" << std::endl;

    start = std::chrono::high_resolution_clock::now();
    mergeSort(tweetsSA_IS_20K, 0, tweetsSA_IS_20K.size() - 1 ,"retweetCount", true);
    end = std::chrono::high_resolution_clock::now();
    duration = end - start;
    std::cout << "Execution time for tweets20K - retweetCount: " << duration.count() << " seconds" << std::endl;

    start = std::chrono::high_resolution_clock::now();
    mergeSort(tweetsSD_IS_30K, 0, tweetsSD_IS_30K.size() - 1 ,"retweetCount", true);
    end = std::chrono::high_resolution_clock::now();
    duration = end - start;
    std::cout << "Execution time for tweets30K - retweetCount: " << duration.count() << " seconds" << std::endl;

    start = std::chrono::high_resolution_clock::now();
    mergeSort(tweetsSD_IS_50K, 0, tweetsSD_IS_50K.size() - 1 ,"retweetCount", true);
    end = std::chrono::high_resolution_clock::now();
    duration = end - start;
    std::cout << "Execution time for tweets50K- retweetCount: " << duration.count() << " seconds" << std::endl;


//Table 1.3
std::cout << "For Table 1.3::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::." << std::endl;
//read the files for Searching
    std::vector<Tweet> tweets_5K = readTweetsFromFile("data/sizes/tweets5K.csv");
    std::vector<Tweet> tweets_10K = readTweetsFromFile("data/sizes/tweets10K.csv");
    std::vector<Tweet> tweets_20K = readTweetsFromFile("data/sizes/tweets20K.csv");
    std::vector<Tweet> tweets_30K = readTweetsFromFile("data/sizes/tweets30K.csv");
    std::vector<Tweet> tweets_50K = readTweetsFromFile("data/sizes/tweets50K.csv");


//For Thershold
std::cout << "------------------- For Thershold ------------------------" <<std::endl;

    start = std::chrono::high_resolution_clock::now();
    countAboveThreshold(tweets_5K, "favoriteCount", 250);
    end = std::chrono::high_resolution_clock::now();
    duration = end - start;
    std::cout << "Execution time for tweets5K: " << duration.count() << " seconds" << std::endl;

    start = std::chrono::high_resolution_clock::now();
    countAboveThreshold(tweets_10K, "favoriteCount", 250);
    end = std::chrono::high_resolution_clock::now();
    duration = end - start;
    std::cout << "Execution time for tweets10K: " << duration.count() << " seconds" << std::endl;

    start = std::chrono::high_resolution_clock::now();
    countAboveThreshold(tweets_20K, "favoriteCount", 250);
    end = std::chrono::high_resolution_clock::now();
    duration = end - start;
    std::cout << "Execution time for tweets20K: " << duration.count() << " seconds" << std::endl;

    start = std::chrono::high_resolution_clock::now();
    countAboveThreshold(tweets_30K, "favoriteCount", 250);
    end = std::chrono::high_resolution_clock::now();
    duration = end - start;
    std::cout << "Execution time for tweets30K: " << duration.count() << " seconds" << std::endl;

    start = std::chrono::high_resolution_clock::now();
    countAboveThreshold(tweets_50K, "favoriteCount", 250);
    end = std::chrono::high_resolution_clock::now();
    duration = end - start;
    std::cout << "Execution time for tweets50K: " << duration.count() << " seconds" << std::endl;


//For Binary Search
std::cout << "------------------- For Binary Search ------------------------" <<std::endl;

//sorting the datasets for binary search
    mergeSort(tweets_5K, 0, tweets_5K.size() - 1 , "tweetID", true);
    mergeSort(tweets_10K,0, tweets_10K.size() - 1 , "tweetID", true);
    mergeSort(tweets_20K, 0, tweets_20K.size() - 1 ,"tweetID", true);
    mergeSort(tweets_30K, 0, tweets_30K.size() - 1 ,"tweetID", true);
    mergeSort(tweets_50K, 0, tweets_50K.size() - 1 ,"tweetID", true);
    
    start = std::chrono::high_resolution_clock::now();
    binarySearch(tweets_5K, 1773335, "tweetID");
    end = std::chrono::high_resolution_clock::now();
    duration = end - start;
    std::cout << "Execution time for tweets5K: " << duration.count() << " seconds" << std::endl;

    start = std::chrono::high_resolution_clock::now();
    binarySearch(tweets_10K, 1773335, "tweetID");
    end = std::chrono::high_resolution_clock::now();
    duration = end - start;
    std::cout << "Execution time for tweets10K: " << duration.count() << " seconds" << std::endl;

    start = std::chrono::high_resolution_clock::now();
    binarySearch(tweets_20K, 1773335, "tweetID");
    end = std::chrono::high_resolution_clock::now();
    duration = end - start;
    std::cout << "Execution time for tweets20K: " << duration.count() << " seconds" << std::endl;

    start = std::chrono::high_resolution_clock::now();
    binarySearch(tweets_30K, 1773335, "tweetID");
    end = std::chrono::high_resolution_clock::now();
    duration = end - start;
    std::cout << "Execution time for tweets30K: " << duration.count() << " seconds" << std::endl;

    start = std::chrono::high_resolution_clock::now();
    binarySearch(tweets_50K, 1773335, "tweetID");
    end = std::chrono::high_resolution_clock::now();
    duration = end - start;
    std::cout << "Execution time for tweets50K: " << duration.count() << " seconds" << std::endl;


    return 0;
}
