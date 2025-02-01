#ifndef ANDGATE_H
#define ANDGATE_H

#include "Gate.h"

class ANDGate : public Gate {
public:
    ANDGate(const std::string& id);
    void evaluate() override;
};

#endif