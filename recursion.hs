--recursive max function
maximum :: (Ord a) => [a] -> a
maximum [] = error "empty list provided"
maximum [x] = x
maximum (x:xs)
	|x > maxTail = x
	| otherwise = maxTail
	where maxTail = maximum xs

-- maximum (x: xs) = max x (maximum xs)

-- it works out quite well with recursoin ad pattern matching
--r

replicate :: (Num i, Ord i) => i -> a -> [a]
replicate n x
	| n<=0 = []
	otherwise = x:replicate (n-1) x

take:: (Num i, Ord i) => i -> [a] -> [a]
take n _
	| n <= 0 = []
take _ [] = []
take n (x:xs) = x : take (n-1) xs

reverse :: [a] -> [a]
reverse [] = []
reverse (x:xs) = reverse xs ++ [x]

repeat:: a->a
repeat x = x:repeat x

zip :: [a] -> [b] -> [(a,b)]
zip _ [] = []
zip [] _ = []
zip (x:xs) (y:ys) = (x,y):zip xs ys

elem :: (Eq a) => a -> [a] -> Bool
elem a [] = False
elem a (x:xs)
	| a == x = True
	| otherwise = elem a xs

--quick sort is generally extremely elegant in haskell ,which is why everyone uses it

quicksort: (Ord a) => [a] -> [a]
quicksort [] = []
quicksort (x:xs) =
	let smallerSorted = quicksort [a | a <- xs, a<=x]
		biggerSorted = quicksort [a | a<- xs, a> x]
	let smallerSorted ++ [x] ++ biggerSorted