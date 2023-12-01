# Assuming your source file is benchmark.cpp
SOURCE = benchmark.cpp
# Output library name with .so extension for dynamic library
LIBRARY_NAME = libbenchmark_lib_csidh.so

# Compile the source file into an object file
OBJECT_FILE = $(patsubst %.cpp, %.o, $(SOURCE))

# Compilation and linking flags for shared library
CXXFLAGS = -std=c++17 -fPIC
LDFLAGS = -shared

# Build the shared library
$(LIBRARY_NAME): $(OBJECT_FILE)
	$(CXX) $(LDFLAGS) -o $@ $<

# Clean up intermediate files
clean:
	rm -f $(OBJECT_FILE) $(LIBRARY_NAME)

