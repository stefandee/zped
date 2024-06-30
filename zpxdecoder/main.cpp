#ifdef __cplusplus
    #include <cstdlib>
#else
    #include <stdlib.h>
#endif
#include <SDL/SDL.h>

#include <stdio.h>

#include <string>
#include <iostream>

//#define VIEW

using namespace std;

const int PAL[16] =
{
  0x000000, // black
  0x00007F, // blue
  0x007F00, // green
  0x007F7F, // cyan
  0x7F0000, // red
  0x7F007F, // magenta
  0x7F3F00, // brown
  0x7F7F7F, // light gray
  0x3F3F3F, // dark gray
  0x0000FF, // light blue
  0x00FF00, // light green
  0x00FFFF, // light cyan
  0xFF0000, // light red
  0xFF00FF, // light magenta
  0xFFFF00, // yellow
  0xFFFFFF  // white
};

SDL_Surface* surfaceZPX, *screen;

bool LoadZPX(const char* fileName)
{
    FILE* fileHandle = fopen(fileName, "r+b");

    if (!fileHandle)
    {
        cout << "Cannot open file " << fileName << endl;
        return false;
    }

    // read the dimensions
    short zpxWidth, zpxHeight;
    unsigned char zpxBPP;

    bool result = fread(&zpxWidth, 1, sizeof(short), fileHandle);

    if (!result)
    {
        cout << "Cannot read width from file." << endl;
    }

    result = fread(&zpxHeight, 1, sizeof(short), fileHandle);

    if (!result)
    {
        cout << "Cannot read height from file." << endl;
    }

    zpxWidth++;
    zpxHeight++;

    // corect the zpxWidth to be dividable by 8
    if (zpxWidth % 8 != 0)
    {
        zpxWidth += 8 - (zpxWidth % 8);
    }

    cout << "Image info: " << zpxWidth << "px x " << zpxHeight << " px" << endl;

    surfaceZPX = SDL_CreateRGBSurface(SDL_SWSURFACE, zpxWidth, zpxHeight, 32, screen->format->Rmask, screen->format->Gmask, screen->format->Bmask, screen->format->Amask);
    //surfaceZPX = SDL_CreateRGBSurface(SDL_HWSURFACE, zpxWidth, zpxHeight, 32, 0xFF0000, 0x00FF00, 0x0000FF, 0xFF000000);

    int index = 0;

    int x = 0, y = 0;

    unsigned char* reds = new unsigned char[zpxWidth / 8];
    unsigned char* greens = new unsigned char[zpxWidth / 8];
    unsigned char* blues = new unsigned char[zpxWidth / 8];
    unsigned char* brights = new unsigned char[zpxWidth / 8];

    SDL_LockSurface(surfaceZPX);

    for(int i = 0; i < zpxHeight; i++)
    {
        result = fread(brights, 1, zpxWidth / 8 * sizeof(char), fileHandle);
        if (!result)
        {
          cout << "Cannot read bright pixels" << endl;
          return false;
        }

        result = fread(reds, 1, zpxWidth / 8 * sizeof(char), fileHandle);
        if (!result)
        {
          cout << "Cannot read red pixels" << endl;
          return false;
        }

        result = fread(greens, 1, zpxWidth / 8 * sizeof(char), fileHandle);
        if (!result)
        {
          cout << "Cannot read green pixels" << endl;
          return false;
        }

        result = fread(blues, 1, zpxWidth / 8 * sizeof(char), fileHandle);
        if (!result)
        {
          cout << "Cannot read blue pixels" << endl;
          return false;
        }

        for(int k = 0; k < zpxWidth / 8; k++)
        {
            int r = reds[k];
            int g = greens[k];
            int b = blues[k];
            int br = brights[k];

            for(int j = 0; j < 8; j++)
            {
                //int palIndex = ((br & 0x1) << 3) | ((r & 0x1) << 2) | ((g & 0x1) << 1) | (b & 0x1);
                //int palIndex = ((b & 0x1) << 3) | ((g & 0x1) << 2) | ((r & 0x1) << 1) | (br & 0x1);
                int palIndex = (((br >> (7 - j)) & 0x1) << 3) | (((r >> (7 - j)) & 0x1) << 2) | (((g >> (7 - j)) & 0x1) << 1) | ((b >> (7 - j)) & 0x1);

                //printf("%x", palIndex);

                *((unsigned int*)surfaceZPX->pixels + y + x) = PAL[palIndex];
                x++;

                if (x >= zpxWidth)
                {
                    x = 0;
                    y += surfaceZPX->pitch / 4;
                    break;
                }

                //r = r >> 1;
                //g = g >> 1;
                //b = b >> 1;
                //br = br >> 1;
            }
        }
    }
    SDL_UnlockSurface(surfaceZPX);

    fclose(fileHandle);
}

void PrintInfo()
{
    cout << "ZPX to BMP converter" << endl;
    cout << "Converts a BGI 16 color getimage data to BMP" << endl << endl;
}

void PrintUsage()
{
    cout << "Usage: ZPX2BMP -in INFILE -out OUTFILE" << endl;
}

int main (int argc, char** argv)
{
    PrintInfo();

    if (argc != 5)
    {
        PrintUsage();
        return 1;
    }

    string inFile  = "",
           outFile = "";

    for(int i = 0; i < argc; i++)
    {
        if (string(argv[i]) == string("-in"))
        {
            if (i + 1 >= argc)
            {
                PrintUsage();
                return 1;
            }

            inFile = string(argv[i + 1]);
            i++;
            continue;
        }

        if (string(argv[i]) == string("-out"))
        {
            if (i + 1 >= argc)
            {
                PrintUsage();
                return 1;
            }

            outFile = string(argv[i + 1]);
            i++;
            continue;
        }
    }

    if (outFile.empty() || inFile.empty())
    {
        PrintUsage();
        return 1;
    }

    cout << inFile << " -> " << outFile << endl;

    // initialize SDL video
    if ( SDL_Init( SDL_INIT_VIDEO ) < 0 )
    {
        printf( "Unable to init SDL: %s\n", SDL_GetError() );
        return 1;
    }

    // make sure SDL cleans up before exit
    atexit(SDL_Quit);

    screen = SDL_SetVideoMode(640, 480, 32, SDL_HWSURFACE|SDL_DOUBLEBUF);

    if ( !screen )
    {
        cout << "Unable to set 640x480 video: " << SDL_GetError() << endl;
        return 1;
    }

    if (!LoadZPX(inFile.c_str()))
    {
        cout << "Error reading input file " << inFile << endl;
        return 1;
    }

    if (SDL_SaveBMP(surfaceZPX, outFile.c_str()) == -1)
    {
        cout << "Error writing the output file " << outFile << endl;
        return 1;
    }

#ifdef VIEW
    SDL_Rect dstrect;
    dstrect.x = (screen->w - surfaceZPX->w) / 2;
    dstrect.y = (screen->h - surfaceZPX->h) / 2;

    // clear screen
    SDL_FillRect(screen, 0, SDL_MapRGB(screen->format, 0, 0, 0));

    // draw bitmap
    SDL_BlitSurface(surfaceZPX, 0, screen, &dstrect);

    // finally, update the screen :)
    SDL_Flip(screen);

    bool done = false;

    while (!done)
    {
        // message processing loop
        SDL_Event event;
        while (SDL_PollEvent(&event))
        {
            // check for messages
            switch (event.type)
            {
                // exit if the window is closed
            case SDL_QUIT:
                done = true;
                break;

                // check for keypresses
            case SDL_KEYDOWN:
                {
                    // exit if ESCAPE is pressed
                    if (event.key.keysym.sym == SDLK_ESCAPE)
                        done = true;
                    break;
                }
            } // end switch
        } // end of message processing
    }

#endif // VIEW

    // free loaded bitmap
    SDL_FreeSurface(surfaceZPX);

    // all is well ;)
    cout << "Conversion succesful." << endl;
    return 0;
}
