#include <iostream>
#include <string>

#include "../include/unit.hpp"

/*
class Unit
{
private:
    std::string m_name;
    float m_cost_per_day;
    float m_base_return_per_day;

public:
    Unit(std::string name, float cost_per_day, float base_return_per_day);
    
    std::string getName() const;
    float getCostPerDay() const;
    float getReturnPerDay() const;
};
*/

Unit::Unit(std::string name, float cost_per_day, float base_return_per_day){
    m_name = name;
    m_cost_per_day = cost_per_day;
    m_base_return_per_day = base_return_per_day;
} 

std::string Unit::getName() const {
    return m_name;
}

float Unit::getCostPerDay() const {
    return m_cost_per_day;
}

float Unit::getReturnPerDay() const {
    return m_base_return_per_day;
}