-- examples from the functinoally solving problems section!

import Data.List

-- so break down the expression into a list of words, and then apply a fold to solvethe problem as the stack
-- so it works reasonably
-- just applies pattern matching toget all the reasonable operators you want and then appends it to the list
-- its quite simply actually, although a slightly different way of thinking about it
-- it is impressive how you just effectively write it in terms of what you want the cmoputatoin to be

solveRPN :: (Num a, Read a) => String -> Float
solveRPN expression = head (foldl foldingFunction [] (words expression))
	where foldingFunction (x:y:ys) "*" = (x*y) : ys
		  foldingFunction (x:y:ys) "+" = (x+y):ys
		  foldingFunction (x:y:ys) "-" = (x-y): ys
		  foldingFunction (x:y:ys) "/" = (x/y):ys
		  foldingFunction (x:y:ys) "^" = (x**y):ys
		  foldingFunction (x: xs) "log" = log x:xs
		  foldingFunction (x:xs) "sin" = sin x: xs
		  foldingFunction xs "sum" = [sum xs]
		  foldingFunction xs "product" = [product xs]
		  foldingFunction xs numberString = read numberString:xs


--define own product function just to make sure it exists and to experiment
-- hopefully this sort of thing would work!
product :: (Num a) => [a] -> a
product xs = foldl f 1 xs
	where f acc (x:xs) = acc*x:xs

-- okay, now for the more difficult graph search problem

data Node = Node Road Road | EndNode Road
data Road = Road Int Node

-- alternatively - so yeah, think about your datatypes, what is the really crucial information to represent
-- may not be completely isomorphic to the obviously apparent problem structure

data Section = Section {getA :: Int, getB::Int, getC::Int} deriving (Show)
type RoadSystem = [Section]

data Label = A | B | C deriving (Show)
type Path = [(Label, Int)]

--the main solving in this divide and conquer algoithm happens in the road step function
-- here it just combines the solution
optimalPath :: RoadSystem -> Path
optimalPath roadSystem = 
	let (betAPath, bestBPath) = foldl roadStep([],[]) roadSystem
	in if sum (map snd bestApath) <= sum (map snd bestBPath)
		then reverse bestApath
		else reverse bestBPath



-- so the individual step function now whichcalculates the optimal path in each section

roadStep :: (Path, Path) -> Section -> (Path, Path)
roadStep (pathA, pathB) (Section a b c) =
	let priceA = sum $ map snd pathA
		priceB = sum $ map snd pathB
		forwardPriceToA = priceA + a
		crossPriceToA = priceB + b + c
		forwardPriceToB = priceB + b
		crossPriceToB = priceA + a + c
		newPathToA = if forwardPriceToA <= crossPriceToA
			then (A, a): pathA
			else (C,c):(B,b):pathB
		newPathToB if forwardPriceToB <=crossPriceToB
			then (B,b):pathB
			else (C,c):(A,a):pathA
		in (newPathToA, newPathToB)


-- next step is converting this into a proper road system!

groupsOf :: Int -> [a] -> [[a]]
groupsOf 0 = undefined
groupsOf _ [] = []
groupsOf n xs = take n xs : groupsOf n (drop n xs)

--and now take into a thing to make it make sense
main = do
	contents <- getContents
	let threes = groupsOf 3 (map read $ lines contents)
	roadSystem = map (\[a,b,c] -> Section a b c) threes
	path = optimalPath roadSystem
	pathString = concat $ map (show .fst) path
	pathPrice = sum $ map snd path
putStrLn $ "The best path to take is: " ++ pathString
putStrLn $ "The price is: " ++ pathPrice