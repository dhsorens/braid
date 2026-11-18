// The first Go examples: arithmetic, a branch and a loop over a slice.
package main

//go:noinline
func Add3(a, b, c uint64) uint64 { return a + b + c }

//go:noinline
func MaxU64(a, b uint64) uint64 {
	if a > b {
		return a
	}
	return b
}

//go:noinline
func SumSlice(xs []uint64) uint64 {
	var s uint64
	for _, x := range xs {
		s += x
	}
	return s
}

func main() {
	println(Add3(1, 2, 3), MaxU64(4, 5), SumSlice([]uint64{1, 2, 3}))
}
