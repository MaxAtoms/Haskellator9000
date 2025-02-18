-- | Normalizes the expression tree generated by the 'Parser' to a tree that can be evaluated.

module Math.Haskellator.Internal.AstProcessingSteps.Normalize (
      convertDimensionTo
    , convertDimensionToBase
    , normalize
    , tryConvertDimensionTo
    ) where

import Data.Maybe

import Math.Haskellator.Internal.Expr
import Math.Haskellator.Internal.Units
import Math.Haskellator.Internal.Utils.Composition
import Math.Haskellator.Internal.Utils.Error

-- | Normalize all values inside the tree to their base units
normalize :: Expr              -- ^ the 'Expr' tree to normalize
          -> Either Error Expr -- ^ the normalized 'Expr' tree
normalize = Right . foldExpr (Val . filterMultiplier . convertDimensionToBase) BinOp UnaryOp Conversion VarBindings Var

-- | Converts a value to its base dimension
--
-- >>> convertDimensionToBase $ Value 1 [UnitExp Kilometer 2, UnitExp Hour 1]
-- 3.6e9 m^2*s
convertDimensionToBase :: AstValue -> AstValue
convertDimensionToBase (Value v u) = foldr doIt (Value v []) u
    where doIt e (Value v' u') = let (Value v'' u'') = convertToBase $ Value 1 e
                                  in Value (v' * v'') (u'':u')

-- | Converts a value to a given dimension. Throws if the conversion is not possible.
--
-- >>> convertDimensionTo (Value 3600000000 [UnitExp Meter 2, UnitExp Second 1]) [UnitExp Kilometer 2, UnitExp Hour 1]
-- 1.0 h*km^2
convertDimensionTo :: AstValue -> Dimension -> AstValue
convertDimensionTo = fromJust .: tryConvertDimensionTo

-- | Tries to convert a value to a given dimension. Returns 'Nothing' if the conversion is not possible.
-- See 'convertDimensionTo' for an example.
tryConvertDimensionTo :: AstValue -> Dimension -> Maybe AstValue
tryConvertDimensionTo (Value v src) target = convertDimensions src target $ Value v []

convertDimensions :: Dimension      -- ^ Source dimension
                  -> Dimension      -- ^ Target dimension
                  -> AstValue       -- ^ Value to convert (Should only contain the numeric value but an empty dimension)
                  -> Maybe AstValue -- ^ Converted value (will contain the correct dimension) or 'Nothing'
convertDimensions [] [] a = Just a
convertDimensions [] _  _ = Nothing
convertDimensions (s:ss) ts v = case convertUnit s ts v of
    Just (v', rest) -> convertDimensions ss rest v'
    Nothing         -> Nothing

-- | Converts a unit to a mathing unit in the target dimension
convertUnit :: UnitExp                     -- ^ Source unit
            -> Dimension                   -- ^ Target dimension
            -> AstValue                    -- ^ Value to convert
            -> Maybe (AstValue, Dimension) -- ^ Converted value and the remaining target dimension or 'Nothing'
convertUnit _ [] _ = Nothing
convertUnit s (t:ts) val@(Value v u) = case convertTo (Value 1 s) t of
    Just (Value v' u') -> Just (Value (v * v') (u':u), ts)
    Nothing            -> do
        (v', rest) <- convertUnit s ts val
        return (v', t:rest)

filterMultiplier :: AstValue -> AstValue
filterMultiplier (Value v u) = Value v $ filter (not . isMultiplier . dimUnit) u
