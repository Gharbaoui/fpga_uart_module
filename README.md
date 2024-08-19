### UART Module
i want to experiment with FPGAs so i have decided to play with tangnano series

#### Disclaimer
I'm not going into depth with all the stuff so if you didn't understand it's probably
not explained that much cuz i have assumed that you are not absolutely beginner
and for now **I intend only to read**

#### UART theory
uart is protocol that allows for data transmission there's multiple configuration i intend to implement
the simplest one 1 start bit 8 data bits and 1 stop bit no parity no multiple stop bits and so on

![](./pics/1.png)

##### Implementation
before we start writing the code, since there's no clock line how would we sync between 
transmitter and receiver well they have to agree on baud rate (how many bits per second)
I decide to choose 115200 bits per second, but my FPGA is 27Mhz thus if i write/read every clock
cycle i'll be working with 27000000 bits per second which is not correct so maybe clock divider 
circuit? well let's think about it, so how would we divide 27Mhz to get to 115200 bps well let's
see 27M/115200 = 234.375 oops there's fraction how would I deal with it there are some tricks to 
deal with it but I'm going to just ignore the fraction part and divide by 234, but what impact 
does that have (removing the fraction part) well if we divide 27M/234=115384.6... the problem is 
that i'll be reading/writing more than expected but is that fine? because we are not that far way
well that depends here's a simple picture that may help

![](./pics/anim_2.png)

red line is the target 115200 exact blue lines are the result of 27M/234=115384.6... at first it 
seems there is no problem

![](./pics/anim_3.png)

now you can start that there is shift but even with the sift the sampled data will be correct

![](./pics/anim_4.png)

now it's clear problem, but what is the effect well I'm not going to deal with this now, and I 
don't believe that I'll see a problem because there's that idle state because when in idle it's 
like reset i believe that it'll be problem when there's consecutive sends but since i intend to 
not operate that fast, if i see problems i'll investigate it

###### Ideas of Implementation
state machine of course i'm going to have some kind of counter remember that i'm not going to 
send every clock cycle, and what are the states at first glance it's seems that 4 is enough
start state, sending/reading state, stop state and idle state, well i tried it's not that simple 
specially because i don't want to read while data is changing it would be great if i read in the 
middle of the da  ta bit not at the edge because the data line is changing and I might get 
corrupted data what i was intending is that start at *idle state* then when rx line goes low we 
move to *start state* and wait for 234 and then move to *reading state* after reading is done go to stop state then idle, let's revise this because of i don't want to reading at the edge
start at idle move to to start but now i'm not going to wait the entire 234 cycles i'll half of 
that but now i can't read since data is not available we move to another state we call it 
**WAITING STATE** and then wait 234 that would put us right in the middle of data bit so we read
thus we effectively avoided that edge problem so we read one bit move back to waiting state and 
wait there 234 and go to reading and so one 8 times then go to stop here's diagram that might 
help

###### Before
![](./pics/st_1.png)

###### After
![](./pics/st_2.png)