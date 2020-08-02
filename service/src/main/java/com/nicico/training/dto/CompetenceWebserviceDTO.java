package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;
import org.apache.commons.lang3.builder.HashCodeBuilder;

import java.io.Serializable;

@Getter
@Setter
@Accessors(chain = true)
public class CompetenceWebserviceDTO implements Serializable {
    public Long id;
    public String code;
    public String latinTitle;
    public String title;
    public String type;
    public String nature;
    public String startDate;
    public String endDate;
    public String legacyCreateDate;
    public String legacyChangeDate;
    public String active;
    public String oldCode;
    public String newCode;
    public String user;
    public String issuable;
    public String comment;
    public String correction;
    public String alignment;
    public Long parentId;

    @Getter
    @Setter
    @ApiModel("CompetenceWebserviceDTOInfoTuple")
    public static class TupleInfo {
        private Long id;
        public String title;
        public Long parentId;
        public String code;

        @Override
        public int hashCode() {
            return new HashCodeBuilder(17, 31).
                    append(code).
                    toHashCode();
        }

        @Override
        public boolean equals(Object obj) {
            if (!(obj instanceof CompetenceWebserviceDTO))
                return false;
            return (this.getId().equals(((TupleInfo) obj).getId()));
        }
    }
}
