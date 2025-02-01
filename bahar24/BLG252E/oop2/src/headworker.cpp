#include <iostream>

#include "../include/headworker.hpp"

/*
class HeadWorker: public Worker
{
public:
?    HeadWorker(Worker &worker);
    
+    float getReturnPerDay();
};
*/

HeadWorker::HeadWorker(Worker &worker):Worker{worker}{}

float HeadWorker::getReturnPerDay(){
    //daily return = (base return) + (experience) ∗ 5
    float daily_return = Unit::getReturnPerDay() + Worker::getExperience() * 5;
    return daily_return;
}