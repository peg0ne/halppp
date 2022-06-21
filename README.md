# HALPPP - basically halp++

### Special operations
- int a = x == 2 ? 0 : 1

### logical operators
##### regular
- [==] Equals
- [!=] Not Equals
- [>] More Than
- [<] Less Than
- [>=] More Than or Equals
- [<=] Less Than or Equals
##### complex
- [=|=] Any Equals
```
if x =|= (1 : 2 : 3) 
same as
if x == 1 || x == 2 || x == 3
```
- [=&=] All Equals
```
if x =&= (1 : 2 : 3)
same as
if x == 1 && x == 2 && x == 3
```
- [=!=] All Not Equals
```
if x =!= (1 : 2 : 3)
same as
if x != 1 && x != 2 && x != 3
```
- [=>=] All More Than
```
if x =>= (1 : 2 : 3)
same as
if x > 1 && x > 2 && x > 3
```
- [=<=] All Less Than
```
if x =<= (1 : 2 : 3)
same as
if x < 1 && x < 2 && x < 3
```
