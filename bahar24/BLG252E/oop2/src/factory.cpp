#include <iostream>
#include <vector>

#include "../include/factory.hpp"
/*
class Factory
{
private:
    float m_capital;
    bool m_is_bankrupt;

    std::vector<Worker> m_workers;
    std::vector<HeadWorker> m_head_workers;
    std::vector<Machine> m_machines;

public:
+    Factory(float capital);

?    void passOneDay();
    
    void addUnit(const Worker &rhs_worker);
    void addUnit(const Machine &rhs_machine); 
    
+    bool isBankrupt() const;
+    float getCapital() const;
    
+    int getWorkerCount() const;
+    int getMachineCount() const;
+    int getHeadWorkerCount() const;
};
*/

Factory::Factory(float capital){
    m_capital = capital;
}

void Factory::passOneDay(){
    //capital = daily returns - daily costs

    float worker_returns =0.0;
    float worker_costs =0.0;
    for(int i = 0 ; i<getWorkerCount(); i++){
        worker_returns += m_workers[i].getReturnPerDay();
        worker_costs += m_workers[i].getCostPerDay();
    }

    float headworker_returns =0.0;
    float headworker_costs =0.0;
    for(int i = 0 ; i<getHeadWorkerCount(); i++){
        headworker_returns += m_head_workers[i].getReturnPerDay();
        headworker_costs += m_head_workers[i].getCostPerDay();
    }

    float machines_returns =0.0;
    float machines_costs =0.0;
    static int is_price_paid = 0;
    for(int i = 0 ; i<getMachineCount(); i++){
        machines_returns += m_machines[i].getReturnPerDay();
        machines_costs += m_machines[i].getCostPerDay();

        if(is_price_paid < getMachineCount()){
            machines_costs += m_machines[i].getPrice();
            is_price_paid++; 
        }
    }

    m_capital = worker_returns - worker_costs + headworker_returns - headworker_costs + machines_returns - machines_costs;
    
    //check for bankruptcy
    if(m_capital < 0){
        m_is_bankrupt = true;
    }

    //headworker change
    int i= 0;
    while(i<getWorkerCount()){
        if(m_workers[i].getExperience()>10){
            m_head_workers.push_back(HeadWorker(m_workers[i]));
            m_workers.erase(m_workers.begin() + i);
        }else{
            ++i;
        }
    }

}    


void Factory::addUnit(const Worker &rhs_worker){}
void Factory::addUnit(const Machine &rhs_machine){} 

bool Factory::isBankrupt() const{
    return m_is_bankrupt;
}

float Factory::getCapital() const{
    return m_capital;
}

int Factory::getWorkerCount() const{
    return m_workers.size();
}
int Factory::getMachineCount() const{
    return m_machines.size();
}
int Factory::getHeadWorkerCount() const{
    return m_head_workers.size();
}