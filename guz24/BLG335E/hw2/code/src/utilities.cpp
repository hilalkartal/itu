#include "methods.h"

std::vector<Item> readItemsFromFile(const std::string& filename) 
{
    //Open csv file
    std::ifstream file(filename);
    std::string line;

    if (!file.is_open()) {
        std::cout << "Error::Can not open the file " << filename << std::endl;
    }else{
        std::vector<Item> items;

        //get rid of the first line
        std::getline(file, line);
        //start reading the tweets
        while(std::getline(file, line)){
            std::stringstream item_line(line);

            std::string stringtoint = "";                   //to convert csv strings to integers
            std::string stringtodouble = "";

            std::getline(item_line, stringtoint, ',');      //convertion of age 
            int age = std::stoll(stringtoint);

            std::getline(item_line, stringtoint, ',');      //convertion of type
            int type = std::stoll(stringtoint);
            
            std::getline(item_line, stringtoint, ',');      //convertion of origin
            int origin = std::stoll(stringtoint);
            
            std::getline(item_line, stringtodouble);           //convertion of rarity
            double rarity = std::stod(stringtodouble);
            
            Item item = {age, type, origin, rarity};
            items.push_back(item);
        }

        return items;
    }

}

void writeItemsToFile(const std::string& filename, const std::vector<Item>& items) 
{
    std::ofstream output_file(filename); 

    if(!(output_file.is_open())){
        std::cout <<"Error::Can not open the file " << filename << std::endl;
        
    }else{
        output_file << "age,type,origin,rarity" <<std::endl;
        for(Item item : items){
            output_file << item.age << "," ;
            output_file << item.type << "," ;
            output_file << item.origin << "," ;
            output_file << item.rarityScore << std::endl;
        }
    }


}
