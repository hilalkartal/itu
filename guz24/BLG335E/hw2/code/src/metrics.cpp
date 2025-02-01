#include "methods.h"

int getMax(std::vector<Item>& items, const std::string& attribute)
{
    int max_val = -1;
    if(items.empty() == true){
        return max_val;
    }
    
    if(attribute == "age"){
        for(Item item : items){
            if(max_val < item.age){
                max_val = item.age;
            }
        }
    }else if(attribute == "type"){
        for(Item item : items){
            if(max_val < item.type){
                max_val = item.type;
            }
        }
    }else if(attribute == "origin"){
        for(Item item : items){
            if(max_val < item.origin){
                max_val = item.origin;
            }
        }
    }else if(attribute == "rarityScore"){
        for(Item item : items){
            if(max_val < item.rarityScore){
                max_val = item.rarityScore;
            }
        }
    }
    return max_val;
}

// min = age - ageWindow
// max = age + ageWindow
// rarityScore = (1 - probability) * (1 + item.age/ageMax)
void calculateRarityScores(std::vector<Item>& items, int ageWindow)
{
    if (items.empty() == true){
        return;
    } 
    for(Item& item : items){
        int min_age = item.age - ageWindow;
        int max_age = item.age + ageWindow;
        int countSimilar = 0;
        int countTotal = 0;
        //count the similar ages

        for(Item subitem : items){
            //COME BACK TO OPTİMİZE 
            if(subitem.age >= min_age && subitem.age <= max_age){
                countTotal++;
                if(subitem.type == item.type && subitem.origin == item.origin){
                    countSimilar++;
                }
            }
        }
    
        //probablity calculation
        double probablity = 0.0;
        if(countTotal > 0){ //probablity changes to countSimilar / countTotal
            probablity = static_cast<double> (countSimilar) / static_cast<double> (countTotal);
            //std::cout << "probablity: " << probablity << std::endl;
        }
        //rarityScore calculation
        item.rarityScore = (double) (1.0 - probablity) * (1.0 + (static_cast<double> (item.age)/static_cast<double>(getMax(items, "age"))));
        //std::cout << "item.rarityScore " << item.rarityScore << std::endl;
    }
    
}
