/*
 * Author: Mehran Golrokhi
 * Created Date: 2020/09/08
 * Last Modified: 2020/09/08
 */

package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class TrainingFileNAReportDTO implements Serializable {

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("GenerateReport")
    public static class GenerateReport {

        private List<List<Cell>> headers;

        private List<String> titlesOfGrid;
        private List<List<String>> dataOfGrid;

        private List<String> titlesOfSummaryGrid;
        private List<List<String>> dataOfSummaryGrid;

    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Cell")
    public static class Cell {

        private String title;
        private boolean bold;

    }
}
