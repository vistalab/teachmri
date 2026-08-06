"""
Psych 204a: Resting State Scrubbing + ICA Spatial Sparsity Simulation (Python version)

Equivalent Python adaptation of restingState.m.

Requirements:
    pip install numpy scipy matplotlib
"""

import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import butter, filtfilt
from scipy.stats import kurtosis


# Match MATLAB script seed
np.random.seed(35)


def lowpass_signal(signal: np.ndarray, cutoff_hz: float, fs_hz: float, order: int = 6) -> np.ndarray:
    """Zero-phase low-pass filter similar to MATLAB lowpass behavior."""
    nyquist = 0.5 * fs_hz
    norm_cutoff = cutoff_hz / nyquist
    b, a = butter(order, norm_cutoff, btype="low")
    return filtfilt(b, a, signal)


def main() -> None:
    # Simulate a signal
    fs = 0.5  # 2-second TR
    t = np.arange(0, 300 + 1 / fs, 1 / fs)  # 5-minute scan inclusive endpoint

    # 1. Create underlying "Neural" signal (Low-frequency 0.01-0.1 Hz)
    neural_shared = lowpass_signal(np.random.randn(t.size), cutoff_hz=0.1, fs_hz=fs)
    sig1 = 0.3 * neural_shared + 0.7 * np.random.randn(t.size)  # Region A
    sig2 = 0.3 * neural_shared + 0.7 * np.random.randn(t.size)  # Region B

    # 2. Add "Nuisance" (Breathing @ ~0.3 Hz + Random Motion Spike)
    breathing = 0.5 * np.sin(2 * np.pi * 0.3 * t)
    motion_spike = np.zeros_like(t)
    motion_spike[99:102] = 5.0  # MATLAB 100:102 -> Python 99:102

    dirty_sig1 = sig1 + breathing + motion_spike
    dirty_sig2 = sig2 + breathing + motion_spike

    # 3. "Scrubbing" - Simple version: Zeroing out the motion spike
    scrubbed_sig1 = dirty_sig1.copy()
    scrubbed_sig2 = dirty_sig2.copy()
    scrubbed_sig1[99:102] = 0
    scrubbed_sig2[99:102] = 0

    # 4. Compare Correlations
    r_dirty = np.corrcoef(dirty_sig1, dirty_sig2)[0, 1]
    r_scrubbed = np.corrcoef(scrubbed_sig1, scrubbed_sig2)[0, 1]

    # Plotting: temporal signals
    fig1, axes = plt.subplots(2, 1, figsize=(10, 7), sharex=True)
    fig1.patch.set_facecolor("white")

    axes[0].plot(t, dirty_sig1, "r", label="Region A")
    axes[0].plot(t, dirty_sig2, "b", label="Region B")
    axes[0].set_title(f"Raw Signals (r = {r_dirty:.2f}) - Dominated by Motion/Breath")
    axes[0].grid(True)

    axes[1].plot(t, scrubbed_sig1, "r", label="Region A")
    axes[1].plot(t, scrubbed_sig2, "b", label="Region B")
    axes[1].set_title(f"Scrubbed Signals (r = {r_scrubbed:.2f}) - Reflecting Shared Low-Freq")
    axes[1].set_xlabel("Time (seconds)")
    axes[1].grid(True)

    print(f"Dirty Correlation: {r_dirty:.2f}")
    print(f"Scrubbed Correlation: {r_scrubbed:.2f}")

    # ICA spatial calculation
    grid_size = 64

    # 1. Generate a Sparse "Network" (The DMN-like signal)
    s1 = np.zeros((grid_size, grid_size))
    s1[19:30, 19:30] = 5  # MATLAB 20:30 -> Python 19:30
    s1 = s1 + 0.5 * np.random.randn(*s1.shape)

    # 2. Generate a Non-Sparse "Network" (Diffuse/Gaussian noise)
    s2 = np.random.randn(grid_size, grid_size)

    # 3. Calculate Excess Kurtosis (A measure of Sparsity/Non-Gaussianity)
    # scipy.stats.kurtosis(..., fisher=True) already returns excess kurtosis
    kurt1 = kurtosis(s1.ravel(), fisher=True, bias=False)
    kurt2 = kurtosis(s2.ravel(), fisher=True, bias=False)

    # Plotting: spatial maps
    fig2, axes2 = plt.subplots(1, 2, figsize=(11, 4.8))
    fig2.patch.set_facecolor("white")

    im1 = axes2[0].imshow(s1, cmap="hot", aspect="equal")
    axes2[0].set_title(f"Sparse Source (Kurtosis: {kurt1:.1f})")
    axes2[0].set_xlabel('ICA "loves" this: high contrast, low occupancy.')
    fig2.colorbar(im1, ax=axes2[0], fraction=0.046, pad=0.04)

    im2 = axes2[1].imshow(s2, cmap="hot", aspect="equal")
    axes2[1].set_title(f"Diffuse Source (Kurtosis: {kurt2:.1f})")
    axes2[1].set_xlabel('ICA "hates" this: looks like a random mix.')
    fig2.colorbar(im2, ax=axes2[1], fraction=0.046, pad=0.04)

    print(f"Sparse Source Kurtosis: {kurt1:.2f} (High non-Gaussianity)")
    print(f"Diffuse Source Kurtosis: {kurt2:.2f} (Near zero/Gaussian)")

    plt.tight_layout()
    plt.show()


if __name__ == "__main__":
    main()
