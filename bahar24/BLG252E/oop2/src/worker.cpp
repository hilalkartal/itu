#include <iostream>
#include <string>

#include "../include/worker.hpp"

/*
class Worker : public Unit
{
private:
+    static inline int m_num_head_workers {};

//headworkers can reach these values as they are derived from this class
protected:
+    static void increaseHeadWorkerCount();      
    
    int m_experience;

public:
+    Worker(std::string name, float cost_per_day, float base_return_per_day);
    
+    float getReturnPerDay();
+    int getExperience() const;
};
*/

Worker::Worker(std::string name, float cost_per_day, float base_return_per_day)
    :Unit{name, cost_per_day, base_return_per_day}
{
    m_experience = 0;
}

int Worker::m_num_head_workers = 0;

void Worker::increaseHeadWorkerCount(){     //static
    m_num_head_workers++;
    std::cout << "A Worker has been promoted to HeadWorker. Current Headworkers are now " << m_num_head_workers << std::endl;
}

float Worker::getReturnPerDay(){
    //daily return = (base return) + (experience) ∗ 2 + (number of head workers) ∗ 3
    //increase the experience

    float daily_return = getReturnPerDay() + getExperience() * 2 + m_num_head_workers * 3;
    m_experience++;

    return daily_return;
}

int Worker::getExperience() const{
    return m_experience;
}