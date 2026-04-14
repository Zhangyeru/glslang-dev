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
    COOPMATAZD = 422,              /* COOPMATAZD  */
    COOPVECNV = 423,               /* COOPVECNV  */
    COOPVECAZD = 424,              /* COOPVECAZD  */
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
    I64IMAGE1D = 518,              /* I64IMAGE1D  */
    U64IMAGE1D = 519,              /* U64IMAGE1D  */
    I64IMAGE2D = 520,              /* I64IMAGE2D  */
    U64IMAGE2D = 521,              /* U64IMAGE2D  */
    I64IMAGE3D = 522,              /* I64IMAGE3D  */
    U64IMAGE3D = 523,              /* U64IMAGE3D  */
    I64IMAGE2DRECT = 524,          /* I64IMAGE2DRECT  */
    U64IMAGE2DRECT = 525,          /* U64IMAGE2DRECT  */
    I64IMAGECUBE = 526,            /* I64IMAGECUBE  */
    U64IMAGECUBE = 527,            /* U64IMAGECUBE  */
    I64IMAGEBUFFER = 528,          /* I64IMAGEBUFFER  */
    U64IMAGEBUFFER = 529,          /* U64IMAGEBUFFER  */
    I64IMAGE1DARRAY = 530,         /* I64IMAGE1DARRAY  */
    U64IMAGE1DARRAY = 531,         /* U64IMAGE1DARRAY  */
    I64IMAGE2DARRAY = 532,         /* I64IMAGE2DARRAY  */
    U64IMAGE2DARRAY = 533,         /* U64IMAGE2DARRAY  */
    I64IMAGECUBEARRAY = 534,       /* I64IMAGECUBEARRAY  */
    U64IMAGECUBEARRAY = 535,       /* U64IMAGECUBEARRAY  */
    I64IMAGE2DMS = 536,            /* I64IMAGE2DMS  */
    U64IMAGE2DMS = 537,            /* U64IMAGE2DMS  */
    I64IMAGE2DMSARRAY = 538,       /* I64IMAGE2DMSARRAY  */
    U64IMAGE2DMSARRAY = 539,       /* U64IMAGE2DMSARRAY  */
    TEXTURECUBEARRAY = 540,        /* TEXTURECUBEARRAY  */
    ITEXTURECUBEARRAY = 541,       /* ITEXTURECUBEARRAY  */
    UTEXTURECUBEARRAY = 542,       /* UTEXTURECUBEARRAY  */
    TEXTURE1D = 543,               /* TEXTURE1D  */
    ITEXTURE1D = 544,              /* ITEXTURE1D  */
    UTEXTURE1D = 545,              /* UTEXTURE1D  */
    TEXTURE1DARRAY = 546,          /* TEXTURE1DARRAY  */
    ITEXTURE1DARRAY = 547,         /* ITEXTURE1DARRAY  */
    UTEXTURE1DARRAY = 548,         /* UTEXTURE1DARRAY  */
    TEXTURE2DRECT = 549,           /* TEXTURE2DRECT  */
    ITEXTURE2DRECT = 550,          /* ITEXTURE2DRECT  */
    UTEXTURE2DRECT = 551,          /* UTEXTURE2DRECT  */
    TEXTUREBUFFER = 552,           /* TEXTUREBUFFER  */
    ITEXTUREBUFFER = 553,          /* ITEXTUREBUFFER  */
    UTEXTUREBUFFER = 554,          /* UTEXTUREBUFFER  */
    TEXTURE2DMS = 555,             /* TEXTURE2DMS  */
    ITEXTURE2DMS = 556,            /* ITEXTURE2DMS  */
    UTEXTURE2DMS = 557,            /* UTEXTURE2DMS  */
    TEXTURE2DMSARRAY = 558,        /* TEXTURE2DMSARRAY  */
    ITEXTURE2DMSARRAY = 559,       /* ITEXTURE2DMSARRAY  */
    UTEXTURE2DMSARRAY = 560,       /* UTEXTURE2DMSARRAY  */
    F16TEXTURE1D = 561,            /* F16TEXTURE1D  */
    F16TEXTURE2D = 562,            /* F16TEXTURE2D  */
    F16TEXTURE3D = 563,            /* F16TEXTURE3D  */
    F16TEXTURE2DRECT = 564,        /* F16TEXTURE2DRECT  */
    F16TEXTURECUBE = 565,          /* F16TEXTURECUBE  */
    F16TEXTURE1DARRAY = 566,       /* F16TEXTURE1DARRAY  */
    F16TEXTURE2DARRAY = 567,       /* F16TEXTURE2DARRAY  */
    F16TEXTURECUBEARRAY = 568,     /* F16TEXTURECUBEARRAY  */
    F16TEXTUREBUFFER = 569,        /* F16TEXTUREBUFFER  */
    F16TEXTURE2DMS = 570,          /* F16TEXTURE2DMS  */
    F16TEXTURE2DMSARRAY = 571,     /* F16TEXTURE2DMSARRAY  */
    SUBPASSINPUT = 572,            /* SUBPASSINPUT  */
    SUBPASSINPUTMS = 573,          /* SUBPASSINPUTMS  */
    ISUBPASSINPUT = 574,           /* ISUBPASSINPUT  */
    ISUBPASSINPUTMS = 575,         /* ISUBPASSINPUTMS  */
    USUBPASSINPUT = 576,           /* USUBPASSINPUT  */
    USUBPASSINPUTMS = 577,         /* USUBPASSINPUTMS  */
    F16SUBPASSINPUT = 578,         /* F16SUBPASSINPUT  */
    F16SUBPASSINPUTMS = 579,       /* F16SUBPASSINPUTMS  */
    SPIRV_INSTRUCTION = 580,       /* SPIRV_INSTRUCTION  */
    SPIRV_EXECUTION_MODE = 581,    /* SPIRV_EXECUTION_MODE  */
    SPIRV_EXECUTION_MODE_ID = 582, /* SPIRV_EXECUTION_MODE_ID  */
    SPIRV_DECORATE = 583,          /* SPIRV_DECORATE  */
    SPIRV_DECORATE_ID = 584,       /* SPIRV_DECORATE_ID  */
    SPIRV_DECORATE_STRING = 585,   /* SPIRV_DECORATE_STRING  */
    SPIRV_TYPE = 586,              /* SPIRV_TYPE  */
    SPIRV_STORAGE_CLASS = 587,     /* SPIRV_STORAGE_CLASS  */
    SPIRV_BY_REFERENCE = 588,      /* SPIRV_BY_REFERENCE  */
    SPIRV_LITERAL = 589,           /* SPIRV_LITERAL  */
    ATTACHMENTEXT = 590,           /* ATTACHMENTEXT  */
    IATTACHMENTEXT = 591,          /* IATTACHMENTEXT  */
    UATTACHMENTEXT = 592,          /* UATTACHMENTEXT  */
    LEFT_OP = 593,                 /* LEFT_OP  */
    RIGHT_OP = 594,                /* RIGHT_OP  */
    INC_OP = 595,                  /* INC_OP  */
    DEC_OP = 596,                  /* DEC_OP  */
    LE_OP = 597,                   /* LE_OP  */
    GE_OP = 598,                   /* GE_OP  */
    EQ_OP = 599,                   /* EQ_OP  */
    NE_OP = 600,                   /* NE_OP  */
    AND_OP = 601,                  /* AND_OP  */
    OR_OP = 602,                   /* OR_OP  */
    XOR_OP = 603,                  /* XOR_OP  */
    MUL_ASSIGN = 604,              /* MUL_ASSIGN  */
    DIV_ASSIGN = 605,              /* DIV_ASSIGN  */
    ADD_ASSIGN = 606,              /* ADD_ASSIGN  */
    MOD_ASSIGN = 607,              /* MOD_ASSIGN  */
    LEFT_ASSIGN = 608,             /* LEFT_ASSIGN  */
    RIGHT_ASSIGN = 609,            /* RIGHT_ASSIGN  */
    AND_ASSIGN = 610,              /* AND_ASSIGN  */
    XOR_ASSIGN = 611,              /* XOR_ASSIGN  */
    OR_ASSIGN = 612,               /* OR_ASSIGN  */
    SUB_ASSIGN = 613,              /* SUB_ASSIGN  */
    STRING_LITERAL = 614,          /* STRING_LITERAL  */
    LEFT_PAREN = 615,              /* LEFT_PAREN  */
    RIGHT_PAREN = 616,             /* RIGHT_PAREN  */
    LEFT_BRACKET = 617,            /* LEFT_BRACKET  */
    RIGHT_BRACKET = 618,           /* RIGHT_BRACKET  */
    LEFT_BRACE = 619,              /* LEFT_BRACE  */
    RIGHT_BRACE = 620,             /* RIGHT_BRACE  */
    DOT = 621,                     /* DOT  */
    COMMA = 622,                   /* COMMA  */
    COLON = 623,                   /* COLON  */
    EQUAL = 624,                   /* EQUAL  */
    SEMICOLON = 625,               /* SEMICOLON  */
    BANG = 626,                    /* BANG  */
    DASH = 627,                    /* DASH  */
    TILDE = 628,                   /* TILDE  */
    PLUS = 629,                    /* PLUS  */
    STAR = 630,                    /* STAR  */
    SLASH = 631,                   /* SLASH  */
    PERCENT = 632,                 /* PERCENT  */
    LEFT_ANGLE = 633,              /* LEFT_ANGLE  */
    RIGHT_ANGLE = 634,             /* RIGHT_ANGLE  */
    VERTICAL_BAR = 635,            /* VERTICAL_BAR  */
    CARET = 636,                   /* CARET  */
    AMPERSAND = 637,               /* AMPERSAND  */
    QUESTION = 638,                /* QUESTION  */
    INVARIANT = 639,               /* INVARIANT  */
    HIGH_PRECISION = 640,          /* HIGH_PRECISION  */
    MEDIUM_PRECISION = 641,        /* MEDIUM_PRECISION  */
    LOW_PRECISION = 642,           /* LOW_PRECISION  */
    PRECISION = 643,               /* PRECISION  */
    PACKED = 644,                  /* PACKED  */
    RESOURCE = 645,                /* RESOURCE  */
    SUPERP = 646,                  /* SUPERP  */
    FLOATCONSTANT = 647,           /* FLOATCONSTANT  */
    INTCONSTANT = 648,             /* INTCONSTANT  */
    UINTCONSTANT = 649,            /* UINTCONSTANT  */
    BOOLCONSTANT = 650,            /* BOOLCONSTANT  */
    IDENTIFIER = 651,              /* IDENTIFIER  */
    TYPE_NAME = 652,               /* TYPE_NAME  */
    CENTROID = 653,                /* CENTROID  */
    IN = 654,                      /* IN  */
    OUT = 655,                     /* OUT  */
    INOUT = 656,                   /* INOUT  */
    STRUCT = 657,                  /* STRUCT  */
    VOID = 658,                    /* VOID  */
    WHILE = 659,                   /* WHILE  */
    BREAK = 660,                   /* BREAK  */
    CONTINUE = 661,                /* CONTINUE  */
    DO = 662,                      /* DO  */
    ELSE = 663,                    /* ELSE  */
    FOR = 664,                     /* FOR  */
    IF = 665,                      /* IF  */
    DISCARD = 666,                 /* DISCARD  */
    RETURN = 667,                  /* RETURN  */
    SWITCH = 668,                  /* SWITCH  */
    CASE = 669,                    /* CASE  */
    DEFAULT = 670,                 /* DEFAULT  */
    TERMINATE_INVOCATION = 671,    /* TERMINATE_INVOCATION  */
    TERMINATE_RAY = 672,           /* TERMINATE_RAY  */
    IGNORE_INTERSECTION = 673,     /* IGNORE_INTERSECTION  */
    UNIFORM = 674,                 /* UNIFORM  */
    SHARED = 675,                  /* SHARED  */
    BUFFER = 676,                  /* BUFFER  */
    TILEIMAGEEXT = 677,            /* TILEIMAGEEXT  */
    FLAT = 678,                    /* FLAT  */
    SMOOTH = 679,                  /* SMOOTH  */
    LAYOUT = 680,                  /* LAYOUT  */
    DOUBLECONSTANT = 681,          /* DOUBLECONSTANT  */
    INT16CONSTANT = 682,           /* INT16CONSTANT  */
    UINT16CONSTANT = 683,          /* UINT16CONSTANT  */
    FLOAT16CONSTANT = 684,         /* FLOAT16CONSTANT  */
    INT32CONSTANT = 685,           /* INT32CONSTANT  */
    UINT32CONSTANT = 686,          /* UINT32CONSTANT  */
    INT64CONSTANT = 687,           /* INT64CONSTANT  */
    UINT64CONSTANT = 688,          /* UINT64CONSTANT  */
    SUBROUTINE = 689,              /* SUBROUTINE  */
    DEMOTE = 690,                  /* DEMOTE  */
    FUNCTION = 691,                /* FUNCTION  */
    PAYLOADNV = 692,               /* PAYLOADNV  */
    PAYLOADINNV = 693,             /* PAYLOADINNV  */
    HITATTRNV = 694,               /* HITATTRNV  */
    CALLDATANV = 695,              /* CALLDATANV  */
    CALLDATAINNV = 696,            /* CALLDATAINNV  */
    PAYLOADEXT = 697,              /* PAYLOADEXT  */
    PAYLOADINEXT = 698,            /* PAYLOADINEXT  */
    HITATTREXT = 699,              /* HITATTREXT  */
    CALLDATAEXT = 700,             /* CALLDATAEXT  */
    CALLDATAINEXT = 701,           /* CALLDATAINEXT  */
    PATCH = 702,                   /* PATCH  */
    SAMPLE = 703,                  /* SAMPLE  */
    NONUNIFORM = 704,              /* NONUNIFORM  */
    COHERENT = 705,                /* COHERENT  */
    VOLATILE = 706,                /* VOLATILE  */
    RESTRICT = 707,                /* RESTRICT  */
    READONLY = 708,                /* READONLY  */
    WRITEONLY = 709,               /* WRITEONLY  */
    NONTEMPORAL = 710,             /* NONTEMPORAL  */
    DEVICECOHERENT = 711,          /* DEVICECOHERENT  */
    QUEUEFAMILYCOHERENT = 712,     /* QUEUEFAMILYCOHERENT  */
    WORKGROUPCOHERENT = 713,       /* WORKGROUPCOHERENT  */
    SUBGROUPCOHERENT = 714,        /* SUBGROUPCOHERENT  */
    NONPRIVATE = 715,              /* NONPRIVATE  */
    SHADERCALLCOHERENT = 716,      /* SHADERCALLCOHERENT  */
    NOPERSPECTIVE = 717,           /* NOPERSPECTIVE  */
    EXPLICITINTERPAMD = 718,       /* EXPLICITINTERPAMD  */
    PERVERTEXEXT = 719,            /* PERVERTEXEXT  */
    PERVERTEXNV = 720,             /* PERVERTEXNV  */
    PERPRIMITIVENV = 721,          /* PERPRIMITIVENV  */
    PERVIEWNV = 722,               /* PERVIEWNV  */
    PERTASKNV = 723,               /* PERTASKNV  */
    PERPRIMITIVEEXT = 724,         /* PERPRIMITIVEEXT  */
    TASKPAYLOADWORKGROUPEXT = 725, /* TASKPAYLOADWORKGROUPEXT  */
    PRECISE = 726                  /* PRECISE  */
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

#line 574 "MachineIndependent/glslang_tab.cpp.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif




int yyparse (glslang::TParseContext* pParseContext);


#endif /* !YY_YY_MACHINEINDEPENDENT_GLSLANG_TAB_CPP_H_INCLUDED  */
