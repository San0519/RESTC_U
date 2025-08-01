# IC-Competition
This repo is for code review and topical discussion about issues on the **2025 CHINA COLLEGE IC COMPETITION**. Please read this README file before any commitments.<br />
All the works in this repo could be done in Chinese or English, but the **later** is encouraged.
## ABOUT COOPERATION
Here we use Github rather than other SMS applications like QQ or Wechat, because it could be more convenient for **asynchrony collaboration** and easier to track the works. Information and ideas provided during discussion will be recorded and automatically classified depending on their topics.
### ISSUE
Issues part is for only something technical, like CPU SPEC or troubles during implementation. This project would be broken down into few parts and tasks, so do the corresponding issue entries. Unfinished tasks could be also presented in issues part in form of **to-do list**.<br />
There will be a toubleshooting entry to record all the issues and problems that have been done previously, you should record them in it.
### DISCUSSION
Any other topics and general discussion could be proposed in a discussion entry. When you create a new discussion, there will be some choices for you, please read their description and follow the instructions. Discussion of topics in "ISSUES" should be put in this part and the **issue ID** should be pasted in each discussion entry if there is any. Replys in "ISSUE" should be only given the possible valid solutions but not the discussion process.
### CODE
Our FPGA prototyping works might be done on the platform of **XILINX**, and the project management of Vivado seems to be hard on Github, so only the `.v` files like verilog headfiles and RTL codes should be uploaded. After each commitment, you should make **code review request** by others before merge them into the main branch. Other core codes but not in `.v` format should obey this rule. The standard of coding should be clarified in one separate section.
### COMMIT
Briefly describe your work in the commit title, and make detailed and necessary in the description box.
## WORKFLOW
1. Determine the requirement and task
2. Begin your own works
3. Create a issue or discussion entry if there is anything wrong
4. Make troubleshooting records
5. Commit your code and create code review request
6. Merge it into the branch after reviewed

## WORKLOAD
1. Application: Tutor and Submission
2. SPEC:
   - Requirements on marks
   - CPU SPEC on requirements
3. Modules:
   - TOP module on SPEC
   - SUB module RTL
   - SUB module tests
   - TOP module verification
   - FPGA prototype
## TimeLine:
3.13: Already dispathed email for searching instructor, waiting for responses  
3.18: Successfully get enrolled. Goodluck.

## DEADLINE
- Preliminary Round: May.20
- ​Regional Final​: July
- National Final​: August

## Code Notation
Current source files: without PC_BP(we are TESTing desisgns without branch prediction)  
Simulation Source： CPU_TEST_TOP,DMEM,IMEM  
其中，IMEM有不同版本，都是基于R_BASIC_TEST写的。R_BASIC_TEST测试了R类型的指令。  
现在例化的IMEM中，是测试的load/store类型指令


