package com.nicico.training.model;




public class Coordinate {
    private Integer horizontal;
    private Double vertical;
    private String seriesName;

    public Coordinate(Integer horizontal, Double vertical, String seriesName) {
        this.horizontal = horizontal;
        this.vertical = vertical;
        this.seriesName = seriesName;
    }

    public Coordinate() {
    }

    public Integer getHorizontal() {
        return horizontal;
    }

    public void setHorizontal(Integer horizontal) {
        this.horizontal = horizontal;
    }

    public Double getVertical() {
        return vertical;
    }

    public void setVertical(Double vertical) {
        this.vertical = vertical;
    }

    public String getSeriesName() {
        return seriesName;
    }

    public void setSeriesName(String seriesName) {
        this.seriesName = seriesName;
    }
}
