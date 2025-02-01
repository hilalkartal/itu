#include <iostream>
#include <string>

#include "../include/machine.hpp"

/*
class Machine : public Unit
{
private:
    float m_failure_probability;
    int m_repair_time;
    float m_price;
    float m_repair_cost;

    int m_days_until_repair;

public:
+    Machine(std::string name, float price, float cost_per_day, float base_return_per_day, float failure_probability, int repair_time, float repair_cost);
+    float getReturnPerDay();
+    float getPrice() const;
};
*/

Machine::Machine(std::string name, float price, float cost_per_day, float base_return_per_day, float failure_probability, int repair_time, float repair_cost)
    :Unit{name, cost_per_day, base_return_per_day}
{
    m_price = price;
    m_failure_probability = failure_probability;
    m_repair_time = repair_time;
    m_repair_cost = repair_cost;
    m_days_until_repair = 0;        //Machine comes working, so there is 0 days to repair
}

float Machine::getPrice() const{
    return m_price;
}

float Machine::getReturnPerDay(){
    //generate a probablity for machine failure
    float prob_fail = static_cast<float>(std::rand()) / RAND_MAX;

    //if the machine fails and it has been working before break the machine
    //no need to break the machine if its already broken
    if(prob_fail > m_failure_probability && m_days_until_repair == 0){
        m_days_until_repair = m_repair_time;
        return (-m_repair_cost);
    }

    //if machine is broken return 0
    if(m_days_until_repair > 0){
        m_days_until_repair--;
        return 0;
    }else{
        return getReturnPerDay();
    }
}