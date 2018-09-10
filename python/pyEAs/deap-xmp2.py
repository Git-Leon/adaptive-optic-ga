t1=linspace(-50,50,100)
sig1=sin(t1/2)+np.random.normal(scale=0.1,size=len(t1))
sig2=sin(t1/2)+np.random.normal(scale=0.1,size=len(t1))



f0=interp1d(t1,sig1,kind="cubic",bounds_error=False,fill_value=-10000)
g=interp1d(t1,sig2,kind="cubic",bounds_error=False,fill_value=10000)
#true value that  I would like to estimate
A=2
B=0.8
C=0

def s(t):
    return A+B*t+C*t*t

def inv_s(t):
    return (t-B)/A

def f(t):
    return f0(s(t))

def hat_s(t,a,b):
    return t*b+a


Ig=arange(t1.min(),t1.max(),1)
If=(Ig-A)/B
I_min=max(If.min(),Ig.min())
I_max=min(If.max(),Ig.max())


J=linspace(min(If.min(),Ig.min()),max(If.max(),Ig.max()))
I=linspace(I_min,I_max,1000)  

#plot(J,f(J),J,g(J))
#ylim(-1.2,1.2)


def cost(x,T=I):
    a=x[0]
    b=x[1]
    return norm(g(b*T+a)-f(T))/len(T),







import operator
import random

import numpy

from deap import base
from deap import benchmarks
from deap import creator
from deap import tools

creator.create("FitnessMax", base.Fitness, weights=(-1.0,))
creator.create("Particle", list, fitness=creator.FitnessMax, speed=list, 
    smin=None, smax=None, best=None)

def generate(size, pmin, pmax, smin, smax):
    part = creator.Particle(random.uniform(pmin, pmax) for _ in range(size)) 
    part.speed = [random.uniform(smin, smax) for _ in range(size)]
    part.smin = smin
    part.smax = smax
    return part

def updateParticle(part, best, phi1, phi2):
    u1 = (random.uniform(0, phi1) for _ in range(len(part)))
    u2 = (random.uniform(0, phi2) for _ in range(len(part)))
    v_u1 = map(operator.mul, u1, map(operator.sub, part.best, part))
    v_u2 = map(operator.mul, u2, map(operator.sub, best, part))
    part.speed = list(map(operator.add, part.speed, map(operator.add, v_u1, v_u2)))
    for i, speed in enumerate(part.speed):
        if speed < part.smin:
            part.speed[i] = part.smin
        elif speed > part.smax:
            part.speed[i] = part.smax
    part[:] = list(map(operator.add, part, part.speed))

toolbox = base.Toolbox()
toolbox.register("particle", generate, size=2, pmin=-6, pmax=6, smin=-3, smax=3)
toolbox.register("population", tools.initRepeat, list, toolbox.particle)
toolbox.register("update", updateParticle, phi1=2.0, phi2=2.0)
toolbox.register("evaluate", cost)

def main():
    pop = toolbox.population(n=5)
    stats = tools.Statistics(lambda ind: ind.fitness.values)
    stats.register("avg", numpy.mean)
    stats.register("std", numpy.std)
    stats.register("min", numpy.min)
    stats.register("max", numpy.max)

    logbook = tools.Logbook()
    logbook.header = ["gen", "evals"] + stats.fields

    GEN = 1000
    best = None

    for g in range(GEN):
        for part in pop:
            part.fitness.values = toolbox.evaluate(part)
            if not part.best or part.best.fitness < part.fitness:
                part.best = creator.Particle(part)
                part.best.fitness.values = part.fitness.values
            if not best or best.fitness < part.fitness:
                best = creator.Particle(part)
                best.fitness.values = part.fitness.values
        for part in pop:
            toolbox.update(part, best)

        # Gather all the fitnesses in one list and print the stats
        logbook.record(gen=g, evals=len(pop), **stats.compile(pop))
        print(logbook.stream)
        print "  Best so far: %s - %s" % (best, best.fitness)

    return pop, logbook, best

pop,logbook,best= main()
print "best=",best,"A,B=",(A,B)
