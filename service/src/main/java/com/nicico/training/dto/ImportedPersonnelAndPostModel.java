package com.nicico.training.dto;

import com.google.common.base.Objects;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.Set;

@Setter
@Getter
public class ImportedPersonnelAndPostModel  {
    private String personnelId;
    private String personnelPersonnelNo;
    private String personnelFirstName;
    private String personnelLastName;
    private String personnelNationalCode;
    private String postId;
    private String postCode;
    private String postTitle;

    @Override
    public boolean equals(final Object obj){
        if (!(obj instanceof ImportedPersonnelAndPostModel)) {
            return false;
        }
        final ImportedPersonnelAndPostModel other = (ImportedPersonnelAndPostModel) obj;
        return Objects.equal(personnelId, other.personnelId)
                && Objects.equal(postCode, other.postCode);
    }
    @Override
    public int hashCode() {
        return Objects.hashCode(personnelId, postCode);
    }

}
