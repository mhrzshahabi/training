package com.nicico.training.model;




public class Coordinate {
    private Integer horizontal;
    private Double vertical;
    private String seriesName;
    private String courseName;

    public Coordinate(Integer horizontal, Double vertical, String seriesName,String courseName) {
        this.horizontal = horizontal;
        this.vertical = vertical;
        this.seriesName = seriesName;
        this.courseName=courseName;
    }

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
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
