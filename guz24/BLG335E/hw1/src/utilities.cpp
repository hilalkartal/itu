#include "tweet.h"

std::vector<Tweet> readTweetsFromFile(const std::string& filename) 
{
    // Open the csv file
    std::ifstream file(filename);
    std::string line;
    
    if (!file.is_open()) {
        std::cout << "Error::Can not open the file" << filename << std::endl;
    }else{
        std::vector<Tweet> tweets;

        //get rid of the first line
        std::getline(file, line);
        //start reading the tweets
        while(std::getline(file, line)){
            std::stringstream tweet_line(line);

            std::string id_chnll = "";
            std::string rc_chnint = "";
            std::string fc_chnint = "";
            
            std::getline(tweet_line, id_chnll, ',');
            std::getline(tweet_line, rc_chnint, ',');
            std::getline(tweet_line, fc_chnint);
            
            long long tweetID = std::stoll(id_chnll);       // Tweet ID (long long for large ID values)
            int retweetCount = std::stoi(rc_chnint);;         // Retweet Count
            int favoriteCount = std::stoi(fc_chnint);; 
    
            //Tweet tweet(tweetID, retweetCount, favoriteCount);
            Tweet tweet = {tweetID, retweetCount, favoriteCount};
            tweets.push_back(tweet);
        }

        return tweets;
    }
}

void writeTweetsToFile(const std::string& filename, const std::vector<Tweet>& tweets) 
{
    std::ofstream output_file(filename); 

    if(!(output_file.is_open())){
        std::cout <<"Error::Can not open the file" << filename << std::endl;
        
    }else{
        output_file << "tweetID,retweet_count,favorite_count" <<std::endl;
        for(Tweet tweet : tweets){
            output_file << tweet.tweetID << "," ;
            output_file << tweet.retweetCount << "," ;
            output_file << tweet.favoriteCount << std::endl;
        }
    }

}