//===========================================
//   demo file
//===========================================
// Initialization
double const PI = 3.141500;
int const MAX_SIZE = 100;
char chr = 34;
double fr = (50 + 10) / chr;
int var;
var = 256 + (chr * MAX_SIZE) / (2 * PI);
// Conditional expressions
if (var > 1000)
	int temp = 0;
else
	if (0)
	int temp = 1;
else
	int temp = 2;
// Cycles
for (int n = 1; n <= 10; n++)
{
int p = 9;
char s = p;
}
for (int n = 1; n <= 20; n += 2)
{
int p = 9;
char s = p;
}
while (chr < 50)
{
chr = chr + 1;
}
// Switchcase
switch (MAX_SIZE)
{
	case (100):
{
MAX_SIZE = 50;
MAX_SIZE = 25;
MAX_SIZE = MAX_SIZE + 1;
break;
}
	case (255):
{
MAX_SIZE = 12;
MAX_SIZE = 6;
break;
}
}
// Input / Output
printf ("%c", chr);
printf ("%f", PI);
printf ("%d", MAX_SIZE);
scanf ("%d", MAX_SIZE);
printf ("%c %f %d", chr, PI, MAX_SIZE);
scanf ("%f", fr);
printf ("%f", fr);
scanf ("%d", var, MAX_SIZE);
//------------------------------------------
