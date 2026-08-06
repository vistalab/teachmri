# Psych 204A Python Scripts

This guide explains how to pull the latest class scripts and run the Python version of the resting-state simulation on a Mac.

Recommended Python version: 3.10 or newer.

## 1) Open Terminal and go to your local course folder

```bash
cd /path/to/your/local/repo/teach/psych221
```

If you are already in the repo, you can check with:

```bash
pwd
```

## 2) Get the latest files from GitHub

```bash
git pull
```

## 3) Create a Python virtual environment (first time only)

```bash
python3 -m venv .venv
```

Activate it:

```bash
source .venv/bin/activate
```

You should now see `(.venv)` at the start of your Terminal prompt.

## 4) Install required packages

```bash
python -m pip install --upgrade pip
pip install -r requirements.txt
```

The `requirements.txt` file in this folder contains:
- numpy
- scipy
- matplotlib

Notes:
- The first run may take a bit longer (for example, Matplotlib font cache setup).
- On later runs, this step is usually fast.

## 5) Run the script

From the `teach/psych221` folder:

```bash
python restingState.py
```

The script will:
- Print correlation and kurtosis values to the Terminal
- Open figures showing signal scrubbing and ICA spatial examples

## 6) Next time you run (quick start)

```bash
cd /path/to/your/local/repo/teach/psych221
source .venv/bin/activate
git pull
python restingState.py
```

## 7) If something fails

### `python: command not found`
Try:

```bash
python3 restingState.py
```

### `ModuleNotFoundError` for numpy/scipy/matplotlib
Make sure your environment is activated and reinstall:

```bash
source .venv/bin/activate
pip install -r requirements.txt
```

### Plot window does not appear
If using a remote session, run locally on your laptop desktop session.

## 8) Reproducibility

`restingState.py` uses a fixed random seed, so outputs are reproducible across runs on the same software stack.
