# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Source path --------------------------------------------------------------
# If extensions (or modules to document with autodoc) are in another directory,
# add these directories to sys.path here.
import pathlib
import sys
src_path = pathlib.Path(__file__).parents[2]/"functions"/"GT_funcs"
src_path = src_path.resolve()
sys.path.insert(0, src_path.as_posix())

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

project = 'Gondola'
copyright = '2024, IRCCS San Camillo | Neurophysiology Lab'
author = 'IRCCS San Camillo | Neurophysiology Lab'
release = '0.1'

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = [
    'sphinxcontrib.matlab',
    'sphinx.ext.duration',
    'sphinx.ext.autodoc',
    'sphinx.ext.autosummary',
    'sphinx.ext.napoleon',
    "myst_parser"
    ]

templates_path = ['_templates']
exclude_patterns = []
primary_domain = "mat"

# -- MATLAB options ----------------------------------------------------------

matlab_src_dir = src_path
matlab_short_links = True
matlab_auto_link = "basic"
matlab_auto_link = "all"
matlab_show_property_default_value = True

# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_theme = 'sphinx_rtd_theme'
# html_theme = 'furo'
# html_theme = 'alabaster'
html_static_path = ['_static']

add_function_parentheses = False
toc_object_entries_show_parents = 'all'
