CXX      = g++
CXXFLAGS = -O2 -fopenmp
LDFLAGS  = -lm

TARGET = sph
SRC    = sph.cpp

.PHONY: all run animate clean
# prerequisites of `all` must run in order: simulate, then plot
.NOTPARALLEL:

# `clean` is deliberately NOT part of `all`: it deletes every .dat file, and
# losing a finished run to an automatic cleanup is not worth the tidiness.
# Run `make clean` yourself when you actually want the data gone.
all: run animate

$(TARGET): $(SRC) kernel.h
	$(CXX) $(CXXFLAGS) $(SRC) -o $(TARGET) $(LDFLAGS)

run: $(TARGET)
	./$(TARGET)

# Start a run with the old frames cleared. Frame numbering restarts at 001 every
# run, so without this an aborted run leaves the previous run's tail behind and
# the frames become a mix of unrelated states.
fresh: $(TARGET)
	rm -f *.dat
	./$(TARGET)

# This needs to be a RECIPE (tab-indented, below the colon). Written as
# `animate: bash plt.gnu` it was a target declaration instead: it made `animate`
# depend on files named `bash` and `plt.gnu`, so make failed with
# "No rule to make target 'bash'" and the plotting never ran at all.
animate:
	bash plt.gnu

clean:
	rm -f $(TARGET) *.dat *.png
