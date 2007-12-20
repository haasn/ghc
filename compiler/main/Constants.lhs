%
% (c) The GRASP/AQUA Project, Glasgow University, 1992-1998
%
\section[Constants]{Info about this compilation}

\begin{code}
{-# OPTIONS -w #-}
-- The above warning supression flag is a temporary kludge.
-- While working on this module you are encouraged to remove it and fix
-- any warnings in the module. See
--     http://hackage.haskell.org/trac/ghc/wiki/Commentary/CodingStyle#Warnings
-- for details

module Constants (module Constants) where

import Data.Bits (shiftL)

-- This magical #include brings in all the everybody-knows-these magic
-- constants unfortunately, we need to be *explicit* about which one
-- we want; if we just hope a -I... will get the right one, we could
-- be in trouble.

#include "HsVersions.h"
#include "../includes/MachRegs.h"
#include "../includes/Constants.h"
#include "../includes/MachDeps.h"
#include "../includes/DerivedConstants.h"

-- import Util
\end{code}

All pretty arbitrary:

\begin{code}
mAX_TUPLE_SIZE = (62 :: Int)    -- Should really match the number
                                -- of decls in Data.Tuple
mAX_CONTEXT_REDUCTION_DEPTH = (20 :: Int)
\end{code}


\begin{code}
-- specialised fun/thunk/constr closure types
mAX_SPEC_THUNK_SIZE   = (MAX_SPEC_THUNK_SIZE :: Int)
mAX_SPEC_FUN_SIZE     = (MAX_SPEC_FUN_SIZE :: Int)
mAX_SPEC_CONSTR_SIZE  = (MAX_SPEC_CONSTR_SIZE :: Int)

-- pre-compiled thunk types
mAX_SPEC_SELECTEE_SIZE	= (MAX_SPEC_SELECTEE_SIZE :: Int)
mAX_SPEC_AP_SIZE        = (MAX_SPEC_AP_SIZE :: Int)

-- closure sizes: these do NOT include the header (see below for header sizes)
mIN_PAYLOAD_SIZE	= (MIN_PAYLOAD_SIZE::Int)
\end{code}

\begin{code}
mIN_INTLIKE, mAX_INTLIKE :: Int	
mIN_INTLIKE = MIN_INTLIKE
mAX_INTLIKE = MAX_INTLIKE

mIN_CHARLIKE, mAX_CHARLIKE :: Int
mIN_CHARLIKE = MIN_CHARLIKE
mAX_CHARLIKE = MAX_CHARLIKE
\end{code}

A section of code-generator-related MAGIC CONSTANTS.

\begin{code}
mAX_Vanilla_REG	= (MAX_VANILLA_REG :: Int)
mAX_Float_REG	= (MAX_FLOAT_REG :: Int)
mAX_Double_REG	= (MAX_DOUBLE_REG :: Int)
mAX_Long_REG    = (MAX_LONG_REG  :: Int)

mAX_Real_Vanilla_REG	= (MAX_REAL_VANILLA_REG :: Int)
mAX_Real_Float_REG	= (MAX_REAL_FLOAT_REG :: Int)
mAX_Real_Double_REG	= (MAX_REAL_DOUBLE_REG :: Int)
#ifdef MAX_REAL_LONG_REG
mAX_Real_Long_REG	= (MAX_REAL_LONG_REG :: Int)
#else
mAX_Real_Long_REG       = (0::Int)
#endif
\end{code}

Closure header sizes.

\begin{code}
sTD_HDR_SIZE       = (STD_HDR_SIZE       :: Int)
pROF_HDR_SIZE      = (PROF_HDR_SIZE      :: Int)
gRAN_HDR_SIZE      = (GRAN_HDR_SIZE      :: Int)
\end{code}

Size of a double in StgWords.

\begin{code}
dOUBLE_SIZE     = SIZEOF_DOUBLE :: Int
wORD64_SIZE     = 8 :: Int
iNT64_SIZE      = wORD64_SIZE
\end{code}

This tells the native code generator the size of the spill
area is has available.

\begin{code}
rESERVED_C_STACK_BYTES = (RESERVED_C_STACK_BYTES :: Int)
\end{code}

The amount of (Haskell) stack to leave free for saving registers when
returning to the scheduler.

\begin{code}
rESERVED_STACK_WORDS = (RESERVED_STACK_WORDS :: Int)
\end{code}

Continuations that need more than this amount of stack should do their
own stack check (see bug #1466).

\begin{code}
aP_STACK_SPLIM = (AP_STACK_SPLIM :: Int)
\end{code}

Size of a word, in bytes

\begin{code}
wORD_SIZE = (SIZEOF_HSWORD :: Int)
wORD_SIZE_IN_BITS = wORD_SIZE * 8 :: Int
\end{code}

Amount of pointer bits used for semi-tagging constructor closures

\begin{code}
tAG_BITS    = (TAG_BITS :: Int)
tAG_MASK    = ((1 `shiftL` tAG_BITS) - 1) :: Int
mAX_PTR_TAG = tAG_MASK :: Int
\end{code}

Size of a C int, in bytes. May be smaller than wORD_SIZE.

\begin{code}
cINT_SIZE = (SIZEOF_INT :: Int)
\end{code}

Size of a storage manager block (in bytes).

\begin{code}
bLOCK_SIZE = (BLOCK_SIZE :: Int)
bLOCK_SIZE_W = (bLOCK_SIZE `quot` wORD_SIZE :: Int)
\end{code}

Number of bits to shift a bitfield left by in an info table.

\begin{code}
bITMAP_BITS_SHIFT = (BITMAP_BITS_SHIFT :: Int)
\end{code}

Constants derived from headers in ghc/includes, generated by the program
../includes/mkDerivedConstants.c.

\begin{code}
#include "../includes/GHCConstants.h"
\end{code}
