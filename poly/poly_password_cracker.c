/*
	POLY_PASSWORD_CRACKER.C
	-----------------------
	by Andrew Trotman (andrew@cs.otago.ac.nz)
*/
#include <stdio.h>

/*
	MAIN()
	------
*/
int main(void)
{
static unsigned char buffer[128];
unsigned char initials, password;
char one, two, three, four;
unsigned short crypt;
long found_initials = 0, found_password = 0;

//initials = 0xC3;
//password = 0xCF;

printf("Initials Hex:");
fgets(buffer, sizeof(buffer), stdin);
sscanf(buffer, "%02x", &initials);

printf("Password Hex:");
fgets(buffer, sizeof(buffer), stdin);
sscanf(buffer, "%02x", &password);

for (one = 'A'; one <= 'Z'; one++)
	for (two = 'A'; two <= 'Z'; two++)
		for (three = 'A'; three <= 'Z'; three++)
			for (four = 'A'; four <= 'Z'; four++)
				{
				crypt = 0;

				crypt = ((crypt << 1) + (crypt >> 8)) & 0x1FF;
				crypt = (crypt & 0xFF) + one + (crypt >> 8);

				crypt = ((crypt << 1) + (crypt >> 8)) & 0x1FF;
				crypt = (crypt & 0xFF) + two + (crypt >> 8);

				crypt = ((crypt << 1) + (crypt >> 8)) & 0x1FF;
				crypt = (crypt & 0xFF) + three + (crypt >> 8);

				crypt = ((crypt << 1) + (crypt >> 8)) & 0x1FF;
				crypt = (crypt & 0xFF) + four + (crypt >> 8);

				if (!found_initials && (crypt & 0xFF) == initials)
					{
					printf("Initials:%c%c%c%c\n", one, two, three, four);
					found_initials = 1;
					}
				if (!found_password && (crypt & 0xFF) == password)
					{
					printf("Password:%c%c%c%c\n", one, two, three, four);
					found_password = 1;
					}
				if (found_initials && found_password)
					return 0;
				}
return 0;
}

