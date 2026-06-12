/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_MACHINEINDEPENDENT_GLSLANG_TAB_CPP_H_INCLUDED
# define YY_YY_MACHINEINDEPENDENT_GLSLANG_TAB_CPP_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    CONST = 258,                   /* CONST  */
    BOOL = 259,                    /* BOOL  */
    INT = 260,                     /* INT  */
    UINT = 261,                    /* UINT  */
    FLOAT = 262,                   /* FLOAT  */
    BVEC2 = 263,                   /* BVEC2  */
    BVEC3 = 264,                   /* BVEC3  */
    BVEC4 = 265,                   /* BVEC4  */
    IVEC2 = 266,                   /* IVEC2  */
    IVEC3 = 267,                   /* IVEC3  */
    IVEC4 = 268,                   /* IVEC4  */
    UVEC2 = 269,                   /* UVEC2  */
    UVEC3 = 270,                   /* UVEC3  */
    UVEC4 = 271,                   /* UVEC4  */
    VEC2 = 272,                    /* VEC2  */
    VEC3 = 273,                    /* VEC3  */
    VEC4 = 274,                    /* VEC4  */
    MAT2 = 275,                    /* MAT2  */
    MAT3 = 276,                    /* MAT3  */
    MAT4 = 277,                    /* MAT4  */
    MAT2X2 = 278,                  /* MAT2X2  */
    MAT2X3 = 279,                  /* MAT2X3  */
    MAT2X4 = 280,                  /* MAT2X4  */
    MAT3X2 = 281,                  /* MAT3X2  */
    MAT3X3 = 282,                  /* MAT3X3  */
    MAT3X4 = 283,                  /* MAT3X4  */
    MAT4X2 = 284,                  /* MAT4X2  */
    MAT4X3 = 285,                  /* MAT4X3  */
    MAT4X4 = 286,                  /* MAT4X4  */
    SAMPLER2D = 287,               /* SAMPLER2D  */
    SAMPLER3D = 288,               /* SAMPLER3D  */
    SAMPLERCUBE = 289,             /* SAMPLERCUBE  */
    SAMPLER2DSHADOW = 290,         /* SAMPLER2DSHADOW  */
    SAMPLERCUBESHADOW = 291,       /* SAMPLERCUBESHADOW  */
    SAMPLER2DARRAY = 292,          /* SAMPLER2DARRAY  */
    SAMPLER2DARRAYSHADOW = 293,    /* SAMPLER2DARRAYSHADOW  */
    ISAMPLER2D = 294,              /* ISAMPLER2D  */
    ISAMPLER3D = 295,              /* ISAMPLER3D  */
    ISAMPLERCUBE = 296,            /* ISAMPLERCUBE  */
    ISAMPLER2DARRAY = 297,         /* ISAMPLER2DARRAY  */
    USAMPLER2D = 298,              /* USAMPLER2D  */
    USAMPLER3D = 299,              /* USAMPLER3D  */
    USAMPLERCUBE = 300,            /* USAMPLERCUBE  */
    USAMPLER2DARRAY = 301,         /* USAMPLER2DARRAY  */
    SAMPLER = 302,                 /* SAMPLER  */
    SAMPLERSHADOW = 303,           /* SAMPLERSHADOW  */
    TEXTURE2D = 304,               /* TEXTURE2D  */
    TEXTURE3D = 305,               /* TEXTURE3D  */
    TEXTURECUBE = 306,             /* TEXTURECUBE  */
    TEXTURE2DARRAY = 307,          /* TEXTURE2DARRAY  */
    ITEXTURE2D = 308,              /* ITEXTURE2D  */
    ITEXTURE3D = 309,              /* ITEXTURE3D  */
    ITEXTURECUBE = 310,            /* ITEXTURECUBE  */
    ITEXTURE2DARRAY = 311,         /* ITEXTURE2DARRAY  */
    UTEXTURE2D = 312,              /* UTEXTURE2D  */
    UTEXTURE3D = 313,              /* UTEXTURE3D  */
    UTEXTURECUBE = 314,            /* UTEXTURECUBE  */
    UTEXTURE2DARRAY = 315,         /* UTEXTURE2DARRAY  */
    ATTRIBUTE = 316,               /* ATTRIBUTE  */
    VARYING = 317,                 /* VARYING  */
    FLOAT16_T = 318,               /* FLOAT16_T  */
    FLOAT32_T = 319,               /* FLOAT32_T  */
    DOUBLE = 320,                  /* DOUBLE  */
    FLOAT64_T = 321,               /* FLOAT64_T  */
    INT64_T = 322,                 /* INT64_T  */
    UINT64_T = 323,                /* UINT64_T  */
    INT32_T = 324,                 /* INT32_T  */
    UINT32_T = 325,                /* UINT32_T  */
    INT16_T = 326,                 /* INT16_T  */
    UINT16_T = 327,                /* UINT16_T  */
    INT8_T = 328,                  /* INT8_T  */
    UINT8_T = 329,                 /* UINT8_T  */
    I64VEC2 = 330,                 /* I64VEC2  */
    I64VEC3 = 331,                 /* I64VEC3  */
    I64VEC4 = 332,                 /* I64VEC4  */
    U64VEC2 = 333,                 /* U64VEC2  */
    U64VEC3 = 334,                 /* U64VEC3  */
    U64VEC4 = 335,                 /* U64VEC4  */
    I32VEC2 = 336,                 /* I32VEC2  */
    I32VEC3 = 337,                 /* I32VEC3  */
    I32VEC4 = 338,                 /* I32VEC4  */
    U32VEC2 = 339,                 /* U32VEC2  */
    U32VEC3 = 340,                 /* U32VEC3  */
    U32VEC4 = 341,                 /* U32VEC4  */
    I16VEC2 = 342,                 /* I16VEC2  */
    I16VEC3 = 343,                 /* I16VEC3  */
    I16VEC4 = 344,                 /* I16VEC4  */
    U16VEC2 = 345,                 /* U16VEC2  */
    U16VEC3 = 346,                 /* U16VEC3  */
    U16VEC4 = 347,                 /* U16VEC4  */
    I8VEC2 = 348,                  /* I8VEC2  */
    I8VEC3 = 349,                  /* I8VEC3  */
    I8VEC4 = 350,                  /* I8VEC4  */
    U8VEC2 = 351,                  /* U8VEC2  */
    U8VEC3 = 352,                  /* U8VEC3  */
    U8VEC4 = 353,                  /* U8VEC4  */
    DVEC2 = 354,                   /* DVEC2  */
    DVEC3 = 355,                   /* DVEC3  */
    DVEC4 = 356,                   /* DVEC4  */
    DMAT2 = 357,                   /* DMAT2  */
    DMAT3 = 358,                   /* DMAT3  */
    DMAT4 = 359,                   /* DMAT4  */
    F16VEC2 = 360,                 /* F16VEC2  */
    F16VEC3 = 361,                 /* F16VEC3  */
    F16VEC4 = 362,                 /* F16VEC4  */
    F16MAT2 = 363,                 /* F16MAT2  */
    F16MAT3 = 364,                 /* F16MAT3  */
    F16MAT4 = 365,                 /* F16MAT4  */
    F32VEC2 = 366,                 /* F32VEC2  */
    F32VEC3 = 367,                 /* F32VEC3  */
    F32VEC4 = 368,                 /* F32VEC4  */
    F32MAT2 = 369,                 /* F32MAT2  */
    F32MAT3 = 370,                 /* F32MAT3  */
    F32MAT4 = 371,                 /* F32MAT4  */
    F64VEC2 = 372,                 /* F64VEC2  */
    F64VEC3 = 373,                 /* F64VEC3  */
    F64VEC4 = 374,                 /* F64VEC4  */
    F64MAT2 = 375,                 /* F64MAT2  */
    F64MAT3 = 376,                 /* F64MAT3  */
    F64MAT4 = 377,                 /* F64MAT4  */
    DMAT2X2 = 378,                 /* DMAT2X2  */
    DMAT2X3 = 379,                 /* DMAT2X3  */
    DMAT2X4 = 380,                 /* DMAT2X4  */
    DMAT3X2 = 381,                 /* DMAT3X2  */
    DMAT3X3 = 382,                 /* DMAT3X3  */
    DMAT3X4 = 383,                 /* DMAT3X4  */
    DMAT4X2 = 384,                 /* DMAT4X2  */
    DMAT4X3 = 385,                 /* DMAT4X3  */
    DMAT4X4 = 386,                 /* DMAT4X4  */
    F16MAT2X2 = 387,               /* F16MAT2X2  */
    F16MAT2X3 = 388,               /* F16MAT2X3  */
    F16MAT2X4 = 389,               /* F16MAT2X4  */
    F16MAT3X2 = 390,               /* F16MAT3X2  */
    F16MAT3X3 = 391,               /* F16MAT3X3  */
    F16MAT3X4 = 392,               /* F16MAT3X4  */
    F16MAT4X2 = 393,               /* F16MAT4X2  */
    F16MAT4X3 = 394,               /* F16MAT4X3  */
    F16MAT4X4 = 395,               /* F16MAT4X4  */
    F32MAT2X2 = 396,               /* F32MAT2X2  */
    F32MAT2X3 = 397,               /* F32MAT2X3  */
    F32MAT2X4 = 398,               /* F32MAT2X4  */
    F32MAT3X2 = 399,               /* F32MAT3X2  */
    F32MAT3X3 = 400,               /* F32MAT3X3  */
    F32MAT3X4 = 401,               /* F32MAT3X4  */
    F32MAT4X2 = 402,               /* F32MAT4X2  */
    F32MAT4X3 = 403,               /* F32MAT4X3  */
    F32MAT4X4 = 404,               /* F32MAT4X4  */
    F64MAT2X2 = 405,               /* F64MAT2X2  */
    F64MAT2X3 = 406,               /* F64MAT2X3  */
    F64MAT2X4 = 407,               /* F64MAT2X4  */
    F64MAT3X2 = 408,               /* F64MAT3X2  */
    F64MAT3X3 = 409,               /* F64MAT3X3  */
    F64MAT3X4 = 410,               /* F64MAT3X4  */
    F64MAT4X2 = 411,               /* F64MAT4X2  */
    F64MAT4X3 = 412,               /* F64MAT4X3  */
    F64MAT4X4 = 413,               /* F64MAT4X4  */
    ATOMIC_UINT = 414,             /* ATOMIC_UINT  */
    ACCSTRUCTNV = 415,             /* ACCSTRUCTNV  */
    ACCSTRUCTEXT = 416,            /* ACCSTRUCTEXT  */
    RAYQUERYEXT = 417,             /* RAYQUERYEXT  */
    FCOOPMATNV = 418,              /* FCOOPMATNV  */
    ICOOPMATNV = 419,              /* ICOOPMATNV  */
    UCOOPMATNV = 420,              /* UCOOPMATNV  */
    COOPMAT = 421,                 /* COOPMAT  */
    COOPMATHW = 422,               /* COOPMATHW  */
    COOPVECNV = 423,               /* COOPVECNV  */
    COOPVECHW = 424,               /* COOPVECHW  */
    HITOBJECTNV = 425,             /* HITOBJECTNV  */
    HITOBJECTATTRNV = 426,         /* HITOBJECTATTRNV  */
    TENSORLAYOUTNV = 427,          /* TENSORLAYOUTNV  */
    TENSORVIEWNV = 428,            /* TENSORVIEWNV  */
    SAMPLERCUBEARRAY = 429,        /* SAMPLERCUBEARRAY  */
    SAMPLERCUBEARRAYSHADOW = 430,  /* SAMPLERCUBEARRAYSHADOW  */
    ISAMPLERCUBEARRAY = 431,       /* ISAMPLERCUBEARRAY  */
    USAMPLERCUBEARRAY = 432,       /* USAMPLERCUBEARRAY  */
    SAMPLER1D = 433,               /* SAMPLER1D  */
    SAMPLER1DARRAY = 434,          /* SAMPLER1DARRAY  */
    SAMPLER1DARRAYSHADOW = 435,    /* SAMPLER1DARRAYSHADOW  */
    ISAMPLER1D = 436,              /* ISAMPLER1D  */
    SAMPLER1DSHADOW = 437,         /* SAMPLER1DSHADOW  */
    SAMPLER2DRECT = 438,           /* SAMPLER2DRECT  */
    SAMPLER2DRECTSHADOW = 439,     /* SAMPLER2DRECTSHADOW  */
    ISAMPLER2DRECT = 440,          /* ISAMPLER2DRECT  */
    USAMPLER2DRECT = 441,          /* USAMPLER2DRECT  */
    SAMPLERBUFFER = 442,           /* SAMPLERBUFFER  */
    ISAMPLERBUFFER = 443,          /* ISAMPLERBUFFER  */
    USAMPLERBUFFER = 444,          /* USAMPLERBUFFER  */
    SAMPLER2DMS = 445,             /* SAMPLER2DMS  */
    ISAMPLER2DMS = 446,            /* ISAMPLER2DMS  */
    USAMPLER2DMS = 447,            /* USAMPLER2DMS  */
    SAMPLER2DMSARRAY = 448,        /* SAMPLER2DMSARRAY  */
    ISAMPLER2DMSARRAY = 449,       /* ISAMPLER2DMSARRAY  */
    USAMPLER2DMSARRAY = 450,       /* USAMPLER2DMSARRAY  */
    SAMPLEREXTERNALOES = 451,      /* SAMPLEREXTERNALOES  */
    SAMPLEREXTERNAL2DY2YEXT = 452, /* SAMPLEREXTERNAL2DY2YEXT  */
    ISAMPLER1DARRAY = 453,         /* ISAMPLER1DARRAY  */
    USAMPLER1D = 454,              /* USAMPLER1D  */
    USAMPLER1DARRAY = 455,         /* USAMPLER1DARRAY  */
    F16SAMPLER1D = 456,            /* F16SAMPLER1D  */
    F16SAMPLER2D = 457,            /* F16SAMPLER2D  */
    F16SAMPLER3D = 458,            /* F16SAMPLER3D  */
    F16SAMPLER2DRECT = 459,        /* F16SAMPLER2DRECT  */
    F16SAMPLERCUBE = 460,          /* F16SAMPLERCUBE  */
    F16SAMPLER1DARRAY = 461,       /* F16SAMPLER1DARRAY  */
    F16SAMPLER2DARRAY = 462,       /* F16SAMPLER2DARRAY  */
    F16SAMPLERCUBEARRAY = 463,     /* F16SAMPLERCUBEARRAY  */
    F16SAMPLERBUFFER = 464,        /* F16SAMPLERBUFFER  */
    F16SAMPLER2DMS = 465,          /* F16SAMPLER2DMS  */
    F16SAMPLER2DMSARRAY = 466,     /* F16SAMPLER2DMSARRAY  */
    F16SAMPLER1DSHADOW = 467,      /* F16SAMPLER1DSHADOW  */
    F16SAMPLER2DSHADOW = 468,      /* F16SAMPLER2DSHADOW  */
    F16SAMPLER1DARRAYSHADOW = 469, /* F16SAMPLER1DARRAYSHADOW  */
    F16SAMPLER2DARRAYSHADOW = 470, /* F16SAMPLER2DARRAYSHADOW  */
    F16SAMPLER2DRECTSHADOW = 471,  /* F16SAMPLER2DRECTSHADOW  */
    F16SAMPLERCUBESHADOW = 472,    /* F16SAMPLERCUBESHADOW  */
    F16SAMPLERCUBEARRAYSHADOW = 473, /* F16SAMPLERCUBEARRAYSHADOW  */
    IMAGE1D = 474,                 /* IMAGE1D  */
    IIMAGE1D = 475,                /* IIMAGE1D  */
    UIMAGE1D = 476,                /* UIMAGE1D  */
    IMAGE2D = 477,                 /* IMAGE2D  */
    IIMAGE2D = 478,                /* IIMAGE2D  */
    UIMAGE2D = 479,                /* UIMAGE2D  */
    IMAGE3D = 480,                 /* IMAGE3D  */
    IIMAGE3D = 481,                /* IIMAGE3D  */
    UIMAGE3D = 482,                /* UIMAGE3D  */
    IMAGE2DRECT = 483,             /* IMAGE2DRECT  */
    IIMAGE2DRECT = 484,            /* IIMAGE2DRECT  */
    UIMAGE2DRECT = 485,            /* UIMAGE2DRECT  */
    IMAGECUBE = 486,               /* IMAGECUBE  */
    IIMAGECUBE = 487,              /* IIMAGECUBE  */
    UIMAGECUBE = 488,              /* UIMAGECUBE  */
    IMAGEBUFFER = 489,             /* IMAGEBUFFER  */
    IIMAGEBUFFER = 490,            /* IIMAGEBUFFER  */
    UIMAGEBUFFER = 491,            /* UIMAGEBUFFER  */
    IMAGE1DARRAY = 492,            /* IMAGE1DARRAY  */
    IIMAGE1DARRAY = 493,           /* IIMAGE1DARRAY  */
    UIMAGE1DARRAY = 494,           /* UIMAGE1DARRAY  */
    IMAGE2DARRAY = 495,            /* IMAGE2DARRAY  */
    IIMAGE2DARRAY = 496,           /* IIMAGE2DARRAY  */
    UIMAGE2DARRAY = 497,           /* UIMAGE2DARRAY  */
    IMAGECUBEARRAY = 498,          /* IMAGECUBEARRAY  */
    IIMAGECUBEARRAY = 499,         /* IIMAGECUBEARRAY  */
    UIMAGECUBEARRAY = 500,         /* UIMAGECUBEARRAY  */
    IMAGE2DMS = 501,               /* IMAGE2DMS  */
    IIMAGE2DMS = 502,              /* IIMAGE2DMS  */
    UIMAGE2DMS = 503,              /* UIMAGE2DMS  */
    IMAGE2DMSARRAY = 504,          /* IMAGE2DMSARRAY  */
    IIMAGE2DMSARRAY = 505,         /* IIMAGE2DMSARRAY  */
    UIMAGE2DMSARRAY = 506,         /* UIMAGE2DMSARRAY  */
    F16IMAGE1D = 507,              /* F16IMAGE1D  */
    F16IMAGE2D = 508,              /* F16IMAGE2D  */
    F16IMAGE3D = 509,              /* F16IMAGE3D  */
    F16IMAGE2DRECT = 510,          /* F16IMAGE2DRECT  */
    F16IMAGECUBE = 511,            /* F16IMAGECUBE  */
    F16IMAGE1DARRAY = 512,         /* F16IMAGE1DARRAY  */
    F16IMAGE2DARRAY = 513,         /* F16IMAGE2DARRAY  */
    F16IMAGECUBEARRAY = 514,       /* F16IMAGECUBEARRAY  */
    F16IMAGEBUFFER = 515,          /* F16IMAGEBUFFER  */
    F16IMAGE2DMS = 516,            /* F16IMAGE2DMS  */
    F16IMAGE2DMSARRAY = 517,       /* F16IMAGE2DMSARRAY  */
    TENSORMAP1D = 518,             /* TENSORMAP1D  */
    TENSORMAP2D = 519,             /* TENSORMAP2D  */
    TENSORMAP3D = 520,             /* TENSORMAP3D  */
    TENSORMAP4D = 521,             /* TENSORMAP4D  */
    I64IMAGE1D = 522,              /* I64IMAGE1D  */
    U64IMAGE1D = 523,              /* U64IMAGE1D  */
    I64IMAGE2D = 524,              /* I64IMAGE2D  */
    U64IMAGE2D = 525,              /* U64IMAGE2D  */
    I64IMAGE3D = 526,              /* I64IMAGE3D  */
    U64IMAGE3D = 527,              /* U64IMAGE3D  */
    I64IMAGE2DRECT = 528,          /* I64IMAGE2DRECT  */
    U64IMAGE2DRECT = 529,          /* U64IMAGE2DRECT  */
    I64IMAGECUBE = 530,            /* I64IMAGECUBE  */
    U64IMAGECUBE = 531,            /* U64IMAGECUBE  */
    I64IMAGEBUFFER = 532,          /* I64IMAGEBUFFER  */
    U64IMAGEBUFFER = 533,          /* U64IMAGEBUFFER  */
    I64IMAGE1DARRAY = 534,         /* I64IMAGE1DARRAY  */
    U64IMAGE1DARRAY = 535,         /* U64IMAGE1DARRAY  */
    I64IMAGE2DARRAY = 536,         /* I64IMAGE2DARRAY  */
    U64IMAGE2DARRAY = 537,         /* U64IMAGE2DARRAY  */
    I64IMAGECUBEARRAY = 538,       /* I64IMAGECUBEARRAY  */
    U64IMAGECUBEARRAY = 539,       /* U64IMAGECUBEARRAY  */
    I64IMAGE2DMS = 540,            /* I64IMAGE2DMS  */
    U64IMAGE2DMS = 541,            /* U64IMAGE2DMS  */
    I64IMAGE2DMSARRAY = 542,       /* I64IMAGE2DMSARRAY  */
    U64IMAGE2DMSARRAY = 543,       /* U64IMAGE2DMSARRAY  */
    TEXTURECUBEARRAY = 544,        /* TEXTURECUBEARRAY  */
    ITEXTURECUBEARRAY = 545,       /* ITEXTURECUBEARRAY  */
    UTEXTURECUBEARRAY = 546,       /* UTEXTURECUBEARRAY  */
    TEXTURE1D = 547,               /* TEXTURE1D  */
    ITEXTURE1D = 548,              /* ITEXTURE1D  */
    UTEXTURE1D = 549,              /* UTEXTURE1D  */
    TEXTURE1DARRAY = 550,          /* TEXTURE1DARRAY  */
    ITEXTURE1DARRAY = 551,         /* ITEXTURE1DARRAY  */
    UTEXTURE1DARRAY = 552,         /* UTEXTURE1DARRAY  */
    TEXTURE2DRECT = 553,           /* TEXTURE2DRECT  */
    ITEXTURE2DRECT = 554,          /* ITEXTURE2DRECT  */
    UTEXTURE2DRECT = 555,          /* UTEXTURE2DRECT  */
    TEXTUREBUFFER = 556,           /* TEXTUREBUFFER  */
    ITEXTUREBUFFER = 557,          /* ITEXTUREBUFFER  */
    UTEXTUREBUFFER = 558,          /* UTEXTUREBUFFER  */
    TEXTURE2DMS = 559,             /* TEXTURE2DMS  */
    ITEXTURE2DMS = 560,            /* ITEXTURE2DMS  */
    UTEXTURE2DMS = 561,            /* UTEXTURE2DMS  */
    TEXTURE2DMSARRAY = 562,        /* TEXTURE2DMSARRAY  */
    ITEXTURE2DMSARRAY = 563,       /* ITEXTURE2DMSARRAY  */
    UTEXTURE2DMSARRAY = 564,       /* UTEXTURE2DMSARRAY  */
    F16TEXTURE1D = 565,            /* F16TEXTURE1D  */
    F16TEXTURE2D = 566,            /* F16TEXTURE2D  */
    F16TEXTURE3D = 567,            /* F16TEXTURE3D  */
    F16TEXTURE2DRECT = 568,        /* F16TEXTURE2DRECT  */
    F16TEXTURECUBE = 569,          /* F16TEXTURECUBE  */
    F16TEXTURE1DARRAY = 570,       /* F16TEXTURE1DARRAY  */
    F16TEXTURE2DARRAY = 571,       /* F16TEXTURE2DARRAY  */
    F16TEXTURECUBEARRAY = 572,     /* F16TEXTURECUBEARRAY  */
    F16TEXTUREBUFFER = 573,        /* F16TEXTUREBUFFER  */
    F16TEXTURE2DMS = 574,          /* F16TEXTURE2DMS  */
    F16TEXTURE2DMSARRAY = 575,     /* F16TEXTURE2DMSARRAY  */
    SUBPASSINPUT = 576,            /* SUBPASSINPUT  */
    SUBPASSINPUTMS = 577,          /* SUBPASSINPUTMS  */
    ISUBPASSINPUT = 578,           /* ISUBPASSINPUT  */
    ISUBPASSINPUTMS = 579,         /* ISUBPASSINPUTMS  */
    USUBPASSINPUT = 580,           /* USUBPASSINPUT  */
    USUBPASSINPUTMS = 581,         /* USUBPASSINPUTMS  */
    F16SUBPASSINPUT = 582,         /* F16SUBPASSINPUT  */
    F16SUBPASSINPUTMS = 583,       /* F16SUBPASSINPUTMS  */
    SPIRV_INSTRUCTION = 584,       /* SPIRV_INSTRUCTION  */
    SPIRV_EXECUTION_MODE = 585,    /* SPIRV_EXECUTION_MODE  */
    SPIRV_EXECUTION_MODE_ID = 586, /* SPIRV_EXECUTION_MODE_ID  */
    SPIRV_DECORATE = 587,          /* SPIRV_DECORATE  */
    SPIRV_DECORATE_ID = 588,       /* SPIRV_DECORATE_ID  */
    SPIRV_DECORATE_STRING = 589,   /* SPIRV_DECORATE_STRING  */
    SPIRV_TYPE = 590,              /* SPIRV_TYPE  */
    SPIRV_STORAGE_CLASS = 591,     /* SPIRV_STORAGE_CLASS  */
    SPIRV_BY_REFERENCE = 592,      /* SPIRV_BY_REFERENCE  */
    SPIRV_LITERAL = 593,           /* SPIRV_LITERAL  */
    ATTACHMENTEXT = 594,           /* ATTACHMENTEXT  */
    IATTACHMENTEXT = 595,          /* IATTACHMENTEXT  */
    UATTACHMENTEXT = 596,          /* UATTACHMENTEXT  */
    LEFT_OP = 597,                 /* LEFT_OP  */
    RIGHT_OP = 598,                /* RIGHT_OP  */
    INC_OP = 599,                  /* INC_OP  */
    DEC_OP = 600,                  /* DEC_OP  */
    LE_OP = 601,                   /* LE_OP  */
    GE_OP = 602,                   /* GE_OP  */
    EQ_OP = 603,                   /* EQ_OP  */
    NE_OP = 604,                   /* NE_OP  */
    AND_OP = 605,                  /* AND_OP  */
    OR_OP = 606,                   /* OR_OP  */
    XOR_OP = 607,                  /* XOR_OP  */
    MUL_ASSIGN = 608,              /* MUL_ASSIGN  */
    DIV_ASSIGN = 609,              /* DIV_ASSIGN  */
    ADD_ASSIGN = 610,              /* ADD_ASSIGN  */
    MOD_ASSIGN = 611,              /* MOD_ASSIGN  */
    LEFT_ASSIGN = 612,             /* LEFT_ASSIGN  */
    RIGHT_ASSIGN = 613,            /* RIGHT_ASSIGN  */
    AND_ASSIGN = 614,              /* AND_ASSIGN  */
    XOR_ASSIGN = 615,              /* XOR_ASSIGN  */
    OR_ASSIGN = 616,               /* OR_ASSIGN  */
    SUB_ASSIGN = 617,              /* SUB_ASSIGN  */
    STRING_LITERAL = 618,          /* STRING_LITERAL  */
    LEFT_PAREN = 619,              /* LEFT_PAREN  */
    RIGHT_PAREN = 620,             /* RIGHT_PAREN  */
    LEFT_BRACKET = 621,            /* LEFT_BRACKET  */
    RIGHT_BRACKET = 622,           /* RIGHT_BRACKET  */
    LEFT_BRACE = 623,              /* LEFT_BRACE  */
    RIGHT_BRACE = 624,             /* RIGHT_BRACE  */
    DOT = 625,                     /* DOT  */
    COMMA = 626,                   /* COMMA  */
    COLON = 627,                   /* COLON  */
    EQUAL = 628,                   /* EQUAL  */
    SEMICOLON = 629,               /* SEMICOLON  */
    BANG = 630,                    /* BANG  */
    DASH = 631,                    /* DASH  */
    TILDE = 632,                   /* TILDE  */
    PLUS = 633,                    /* PLUS  */
    STAR = 634,                    /* STAR  */
    SLASH = 635,                   /* SLASH  */
    PERCENT = 636,                 /* PERCENT  */
    LEFT_ANGLE = 637,              /* LEFT_ANGLE  */
    RIGHT_ANGLE = 638,             /* RIGHT_ANGLE  */
    VERTICAL_BAR = 639,            /* VERTICAL_BAR  */
    CARET = 640,                   /* CARET  */
    AMPERSAND = 641,               /* AMPERSAND  */
    QUESTION = 642,                /* QUESTION  */
    INVARIANT = 643,               /* INVARIANT  */
    HIGH_PRECISION = 644,          /* HIGH_PRECISION  */
    MEDIUM_PRECISION = 645,        /* MEDIUM_PRECISION  */
    LOW_PRECISION = 646,           /* LOW_PRECISION  */
    PRECISION = 647,               /* PRECISION  */
    PACKED = 648,                  /* PACKED  */
    RESOURCE = 649,                /* RESOURCE  */
    SUPERP = 650,                  /* SUPERP  */
    FLOATCONSTANT = 651,           /* FLOATCONSTANT  */
    INTCONSTANT = 652,             /* INTCONSTANT  */
    UINTCONSTANT = 653,            /* UINTCONSTANT  */
    BOOLCONSTANT = 654,            /* BOOLCONSTANT  */
    IDENTIFIER = 655,              /* IDENTIFIER  */
    TYPE_NAME = 656,               /* TYPE_NAME  */
    CENTROID = 657,                /* CENTROID  */
    IN = 658,                      /* IN  */
    OUT = 659,                     /* OUT  */
    INOUT = 660,                   /* INOUT  */
    STRUCT = 661,                  /* STRUCT  */
    VOID = 662,                    /* VOID  */
    WHILE = 663,                   /* WHILE  */
    BREAK = 664,                   /* BREAK  */
    CONTINUE = 665,                /* CONTINUE  */
    DO = 666,                      /* DO  */
    ELSE = 667,                    /* ELSE  */
    FOR = 668,                     /* FOR  */
    IF = 669,                      /* IF  */
    DISCARD = 670,                 /* DISCARD  */
    RETURN = 671,                  /* RETURN  */
    SWITCH = 672,                  /* SWITCH  */
    CASE = 673,                    /* CASE  */
    DEFAULT = 674,                 /* DEFAULT  */
    TERMINATE_INVOCATION = 675,    /* TERMINATE_INVOCATION  */
    TERMINATE_RAY = 676,           /* TERMINATE_RAY  */
    IGNORE_INTERSECTION = 677,     /* IGNORE_INTERSECTION  */
    UNIFORM = 678,                 /* UNIFORM  */
    SHARED = 679,                  /* SHARED  */
    BUFFER = 680,                  /* BUFFER  */
    TILEIMAGEEXT = 681,            /* TILEIMAGEEXT  */
    FLAT = 682,                    /* FLAT  */
    SMOOTH = 683,                  /* SMOOTH  */
    LAYOUT = 684,                  /* LAYOUT  */
    DOUBLECONSTANT = 685,          /* DOUBLECONSTANT  */
    INT16CONSTANT = 686,           /* INT16CONSTANT  */
    UINT16CONSTANT = 687,          /* UINT16CONSTANT  */
    FLOAT16CONSTANT = 688,         /* FLOAT16CONSTANT  */
    INT32CONSTANT = 689,           /* INT32CONSTANT  */
    UINT32CONSTANT = 690,          /* UINT32CONSTANT  */
    INT64CONSTANT = 691,           /* INT64CONSTANT  */
    UINT64CONSTANT = 692,          /* UINT64CONSTANT  */
    SUBROUTINE = 693,              /* SUBROUTINE  */
    DEMOTE = 694,                  /* DEMOTE  */
    FUNCTION = 695,                /* FUNCTION  */
    PAYLOADNV = 696,               /* PAYLOADNV  */
    PAYLOADINNV = 697,             /* PAYLOADINNV  */
    HITATTRNV = 698,               /* HITATTRNV  */
    CALLDATANV = 699,              /* CALLDATANV  */
    CALLDATAINNV = 700,            /* CALLDATAINNV  */
    PAYLOADEXT = 701,              /* PAYLOADEXT  */
    PAYLOADINEXT = 702,            /* PAYLOADINEXT  */
    HITATTREXT = 703,              /* HITATTREXT  */
    CALLDATAEXT = 704,             /* CALLDATAEXT  */
    CALLDATAINEXT = 705,           /* CALLDATAINEXT  */
    PATCH = 706,                   /* PATCH  */
    SAMPLE = 707,                  /* SAMPLE  */
    NONUNIFORM = 708,              /* NONUNIFORM  */
    COHERENT = 709,                /* COHERENT  */
    VOLATILE = 710,                /* VOLATILE  */
    RESTRICT = 711,                /* RESTRICT  */
    READONLY = 712,                /* READONLY  */
    WRITEONLY = 713,               /* WRITEONLY  */
    NONTEMPORAL = 714,             /* NONTEMPORAL  */
    DEVICECOHERENT = 715,          /* DEVICECOHERENT  */
    QUEUEFAMILYCOHERENT = 716,     /* QUEUEFAMILYCOHERENT  */
    WORKGROUPCOHERENT = 717,       /* WORKGROUPCOHERENT  */
    SUBGROUPCOHERENT = 718,        /* SUBGROUPCOHERENT  */
    NONPRIVATE = 719,              /* NONPRIVATE  */
    SHADERCALLCOHERENT = 720,      /* SHADERCALLCOHERENT  */
    NOPERSPECTIVE = 721,           /* NOPERSPECTIVE  */
    EXPLICITINTERPAMD = 722,       /* EXPLICITINTERPAMD  */
    PERVERTEXEXT = 723,            /* PERVERTEXEXT  */
    PERVERTEXNV = 724,             /* PERVERTEXNV  */
    PERPRIMITIVENV = 725,          /* PERPRIMITIVENV  */
    PERVIEWNV = 726,               /* PERVIEWNV  */
    PERTASKNV = 727,               /* PERTASKNV  */
    PERPRIMITIVEEXT = 728,         /* PERPRIMITIVEEXT  */
    TASKPAYLOADWORKGROUPEXT = 729, /* TASKPAYLOADWORKGROUPEXT  */
    PRECISE = 730                  /* PRECISE  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 72 "MachineIndependent/glslang.y"

    struct {
        glslang::TSourceLoc loc;
        union {
            glslang::TString *string;
            int i;
            unsigned int u;
            long long i64;
            unsigned long long u64;
            bool b;
            double d;
        };
        glslang::TSymbol* symbol;
    } lex;
    struct {
        glslang::TSourceLoc loc;
        glslang::TOperator op;
        union {
            TIntermNode* intermNode;
            glslang::TIntermNodePair nodePair;
            glslang::TIntermTyped* intermTypedNode;
            glslang::TAttributes* attributes;
            glslang::TSpirvRequirement* spirvReq;
            glslang::TSpirvInstruction* spirvInst;
            glslang::TSpirvTypeParameters* spirvTypeParams;
        };
        union {
            glslang::TPublicType type;
            glslang::TFunction* function;
            glslang::TParameter param;
            glslang::TTypeLoc typeLine;
            glslang::TTypeList* typeList;
            glslang::TArraySizes* arraySizes;
            glslang::TIdentifierList* identifierList;
        };
        glslang::TTypeParameters* typeParameters;
    } interm;

#line 578 "MachineIndependent/glslang_tab.cpp.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif




int yyparse (glslang::TParseContext* pParseContext);


#endif /* !YY_YY_MACHINEINDEPENDENT_GLSLANG_TAB_CPP_H_INCLUDED  */
