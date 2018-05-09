let
  pkgs = import <nixpkgs> {};
  python = pkgs.python36;
  ply310 = pkgs.python36Packages.buildPythonPackage (rec {
    name = "ply-3.10";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/ply/${name}.tar.gz";
      sha256 = "96e94af7dd7031d8d6dd6e2a8e0de593b511c211a86e28a9c9621c275ac8bacb";
    };

    checkPhase = ''
      ${python.interpreter} test/testlex.py
      ${python.interpreter} test/testyacc.py
    '';

    # Test suite appears broken
    doCheck = false;

    meta = {
      homepage = http://www.dabeaz.com/ply/;

      description = "PLY (Python Lex-Yacc), an implementation of the lex and yacc parsing tools for Python";

      longDescription = ''
        PLY is an implementation of lex and yacc parsing tools for Python.
        In a nutshell, PLY is nothing more than a straightforward lex/yacc
        implementation.  Here is a list of its essential features: It's
        implemented entirely in Python; It uses LR-parsing which is
        reasonably efficient and well suited for larger grammars; PLY
        provides most of the standard lex/yacc features including support for
        empty productions, precedence rules, error recovery, and support for
        ambiguous grammars; PLY is straightforward to use and provides very
        extensive error checking; PLY doesn't try to do anything more or less
        than provide the basic lex/yacc functionality.  In other words, it's
        not a large parsing framework or a component of some larger system.
      '';

      maintainers = [ ];
    };
  });
  IBMQuantumExperience = pkgs.python36Packages.buildPythonPackage rec {
    pname = "IBMQuantumExperience";
    version = "1.9.1";

    src = pkgs.python36.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "480cce2ca285368432b7d00b9cd702a4f8a1c9d69914ba6f65e08099e151e407";
    };

    doCheck = false;

    buildInputs = with pkgs.python36Packages; [
      requests
      requests_ntlm
    ];

    meta = {
      homepage = https://github.com/QISKit/qiskit-api-py;
      description = "A Python library for the Quantum Experience API";
    };
  };
  networkx20 = pkgs.python36Packages.buildPythonPackage rec {
	pname = "networkx";
	version = "2.0";

	src = pkgs.python36Packages.fetchPypi {
	  inherit pname version;
	  extension = "zip";
	  sha256 = "cd5ff8f75d92c79237f067e2f0876824645d37f017cfffa5b7c9678cae1454aa";
	};

	checkInputs = with pkgs.python36Packages; [ nose ];
	propagatedBuildInputs = with pkgs.python36Packages; [ decorator ];

	meta = {
	  homepage = "https://networkx.github.io/";
	  description = "Library for the creation, manipulation, and study of the structure, dynamics, and functions of complex networks";
	};
  }; 
  qiskit = pkgs.python36Packages.buildPythonPackage rec {
    pname = "qiskit";
    version = "0.4.15";

    src = pkgs.python36.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "bd126a35189f8303df41cb7b7f26b0d06e1fabf61f4fd567b8ec356d31170141";
    };

    doCheck = false;

    propagatedBuildInputs = with pkgs.python36Packages; [
      numpy
      matplotlib
      networkx20
      numpy
      ply310
      scipy
      sympy
      pillow
      cffi
      IBMQuantumExperience
      requests
      requests_ntlm
    ];

    meta = {
      homepage = https://github.com/QISKit/qiskit-sdk-py;
      description = "Quantum Software Development Kit for writing quantum computing experiments, programs, and applications.";
    };
  };
  qasm2image = pkgs.python36Packages.buildPythonPackage rec {
    pname = "qasm2image";
    version = "0.5.0";

    src = pkgs.fetchFromGitHub {
      owner = "nelimeee";
      repo = "qasm2image";
      rev = "7f3c3e4d1701b8b284ef0352aa3a47722ebbbcaa";
      sha256 = "129xlpwp36h2czzw1wcl8df2864zg3if2gaad1v18ah1cf68b0f3";
    };

    doCheck = false;

    propagatedBuildInputs = with pkgs.python36Packages; [
      cairocffi
      cairosvg
      cffi
      qiskit
      svgwrite
    ];
  };
in
with pkgs;
stdenv.mkDerivation rec {
  name = "ibmqtest";

  buildInputs = [
    bashInteractive
    python36
    qiskit
    qasm2image
    python36Packages.jupyter
  ];
}
